extends Control

signal upgrade

onready var particle = preload("res://scenes/shared/single_particle_effect.tscn");

export var label = "My upgrade"
export(Texture) var spriteTexture;

export var help_index = -1
export var help_page = "destroyer"

export var basePrice: int = 0;
export var levelupPriceIncrease: int = 10;
export var levelupPricePercentIncrease: int = 10;
export(Enums.SaveFlag) var saveFlag
export var levelCap = -1;
export var locked = false;

var level = 0;
var price = 0;

func _ready():
	$"%LabelTitle".text = label
	$"%Icon".texture = spriteTexture
	
	setImportedLevel(Save.importSave(saveFlag, 0))
	
	$Help.help_index = help_index
	$Help.help_page = help_page
	
	updateUi();

func updateUi():
	$"%LabelPrice".text = String(price);
	$"%LabelLevel".visible = true
	if(level == levelCap):
		$"%LabelLevel".text = "max";
		$"%LabelPrice".visible = false
	elif(level > 0):
		$"%LabelLevel".text = String(level);
	else:
		$"%LabelLevel".text = "";

func action():
	emit_signal("upgrade");

func calculatePriceIncrease(_currentPrice, _priceIncreaseValue, _priceIncreasePercent):
	var output = _currentPrice + _priceIncreaseValue;
	var increase: float = 0;
	if(_priceIncreasePercent != 0):
		increase = (float(output) / float(100)) * float(_priceIncreasePercent);
	output = output + ceil(increase);
	return output;

func applyNextLevelUiUpdate():
	if(Globals.bolts < price):
		return false;
	if(levelCap != -1):
		if(level >= levelCap):
			return false;
	Globals.bolts -= price;
	level = level + 1;
	var p = particle.instance();
	p.position = $"%particle_point".position;
	add_child(p);
	$AudioStreamPlayer.play();
	if(levelCap != -1):
		if(level >= levelCap):
			$"%LabelPrice".visible = false;
	
	price =+ calculatePriceIncrease(price,levelupPriceIncrease,levelupPricePercentIncrease);
	updateUi();
	#setPayable(Globals.bots);
	#emit_signal("levelChanged");
	return true;

func setImportedLevel(save_level):
	level = save_level;
	for i in save_level:
		price =+ calculatePriceIncrease(price,levelupPriceIncrease,levelupPricePercentIncrease);
		
	for s in save_level:
		action();

func _on_MouseOverlay_button_down():
	if(locked == true):
		return
	if applyNextLevelUiUpdate():
		action()
	
	Save.exportSave(saveFlag, level)
	Save.saveGame()
