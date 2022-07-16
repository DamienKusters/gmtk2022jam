extends Control

enum Upgrade { ADD_DICE, UPGRADE_DICE, DUNGEON_MASTER, DICE_TOWER, REROLL, DICE_TRAY, CONTRACT };

onready var g = $"/root/Globals";

export var title: String = "Upgrade Name";
export var basePrice: int = 0;
export var levelupPriceIncrease: int = 10;
export var levelupPricePercentIncrease: int = 10;
export(Upgrade) var kind;
#export var level: int = 0;
export(Texture) var spriteTexture;

var level = 0;
var price = 0;

func _ready():
	$LabelTitle.text = title;
	$Control/TextureRect.texture = spriteTexture;
	price = basePrice;
	updateUi();
	
func updateUi():
	$LabelPrice.text = "$" + String(price);
	if(level > 0):
		$LabelLevel.text = String(level);
	else:
		$LabelLevel.text = "";
		
func _on_MouseOverlay_button_down():
	if(g.currency < price):
		return;
	g.removeCurrency(price);
	level = level + 1;
	$CPUParticles2D.restart();
	
	price = price + levelupPriceIncrease;
	var priceIncrease: float = (float(price) / float(100)) * float(10);
	price = price + ceil(priceIncrease);
	updateUi();
	action();
	pass # Replace with function body.
	
func action():
	if(kind == 0):
		g.addDice();
	if(kind == 1):
		g.upgradeDice();
	if(kind == 2 || kind == 3):
		$Timer.stop();
		var timeDecrease: float = (float($Timer.wait_time) / float(100)) * float(10);
		$Timer.wait_time = float($Timer.wait_time) - timeDecrease;
		$Timer.start();
	if(kind == 4):
		pass
	if(kind == 6):
		# contract
		pass
	if(kind == 5):
		pass # dice tray
		

func _on_Timer_timeout():
	if(kind == 2):
		g.rollRandomDice();
	if(kind == 3):
		g.rollRandomDice();
		g.rollRandomDice();
		g.rollRandomDice();
		g.rollRandomDice();
	pass # Replace with function body.
