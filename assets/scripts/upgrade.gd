extends Control

signal levelChanged;

onready var particle = preload("res://scenes/shared/single_particle_effect.tscn");

export var locked = false;
export var title: String = "Upgrade Name";
export var basePrice: int = 0;
export var levelupPriceIncrease: int = 10;
export var levelupPricePercentIncrease: int = 10;
export(Enums.Upgrade) var kind;
export var levelCap = -1;
export(Texture) var spriteTexture;
export(String) var description;
export(Enums.SaveFlag) var saveFlag
var test_contract;
var target_enemy: EnemyModel

var level = 0;
var price = 0;

func _ready():
	$LabelTitle.text = title;
	$Control/TextureRect.texture = spriteTexture;
	
	price = basePrice;
	
	if kind != Enums.Upgrade.ASCEND:
		setImportedLevel(Save.importSave(saveFlag, 0))
	
	updateUi();
	if(kind == 1):
		var _a = Globals.connect("upgradeDiceSuccess", self, "applyNextLevelUiUpdate");
	if(kind == 4):
		updateUi();
		var _a = Globals.connect("damageEnemy", self, "enemyDamaged");
		emit_signal("levelChanged");	
	if(kind == 6):
		var _a = Globals.connect("enemyKilled", self, "enemyKilled");
		if level >= levelCap:
			locked = true
		$enemyLocker.visible = false;
	$enemyLocker.visible = false;
	var _a = Globals.connect("currencyUpdated", self, "setPayable");
	setPayable(Globals.currency);
	if kind == Enums.Upgrade.ASCEND:
		$bg.self_modulate = Color('8E6811');
	
func updateUi():
	$LabelPrice.text = String(price);
	if(level == levelCap):
		$LabelLevel.text = "max";
		$LabelPrice.text = "";
	elif(level > 0):
		$LabelLevel.text = String(level);
	else:
		$LabelLevel.text = "";

func completeContract():
	locked = false
	$Tween.interpolate_property(self, "margin_left", self.margin_left, 0, 1.5, Tween.TRANS_ELASTIC);
	$Tween.start();
	$enemyLocker.visible = false;
	$LabelPrice.visible = true;
	Save.exportSave(Enums.SaveFlag.TARGET_ENEMY_BEATEN, 1)

func setContract():
	if level != levelCap:
		locked = true
		$Tween.interpolate_property(self, "margin_left", self.margin_left, 100, 1.5, Tween.TRANS_ELASTIC);
		$Tween.start();
		$LabelPrice.visible = false;
		Save.exportSave(Enums.SaveFlag.TARGET_ENEMY_BEATEN, 0)
	else:
		updateUi()

func tween_completed():
	if(locked):
		$enemyLocker.visible = true;
		$enemyLocker/TextureRect.texture = target_enemy.sprite
	else:
		$enemyLocker.visible = false;

func _on_MouseOverlay_button_down():
	if(locked == true):
		return;
	if(kind == 1):# Quick fix for upgrade dice
		action();
	else:
		if(applyNextLevelUiUpdate()):
			action();
	Save.exportSave(saveFlag, level)

func enemyKilled(enemy):
	if locked == false:
		return
	if(enemy.name == target_enemy.name):
		completeContract();

func applyNextLevelUiUpdate():
	if(Globals.currency < price):
		return false;
	if(levelCap != -1):
		if(level >= levelCap):
			return;
	Globals.removeCurrency(price);
	level = level + 1;
	var p = particle.instance();
	p.position = $particle_point.position;
	add_child(p);
	$AudioStreamPlayer.play();
	if(levelCap != -1):
		if(level >= levelCap):
			$LabelPrice.visible = false;
	
	price =+ calculatePriceIncrease(price,levelupPriceIncrease,levelupPricePercentIncrease);
	updateUi();
	setPayable(Globals.currency);
	emit_signal("levelChanged");
	return true;

func calculatePriceIncrease(_currentPrice, _priceIncreaseValue, _priceIncreasePercent):
	var output = _currentPrice + _priceIncreaseValue;
	var increase: float = 0;
	if(_priceIncreasePercent != 0):
		increase = (float(output) / float(100)) * float(_priceIncreasePercent);
	output = output + ceil(increase);
	return output;

func action():
	if(kind == Enums.Upgrade.ADD_DICE):
		Globals.emit_signal("addDice", 0);
	if(kind == Enums.Upgrade.UPGRADE_DICE):
		Globals.tryUpgradeDice(price);
	if(kind == Enums.Upgrade.DUNGEON_MASTER):
		$Timer.stop();
		var tim = $Timer.wait_time;
		if($Timer.wait_time <= 1):
			$Timer.wait_time = float($Timer.wait_time) - .1;# TODO: FIX
		elif(tim <= 2):
			$Timer.wait_time = float($Timer.wait_time) - .2;
		elif(tim <= 3):
			$Timer.wait_time = float($Timer.wait_time) - .3;
		elif(tim <= 4):
			$Timer.wait_time = float($Timer.wait_time) - .4;
		else:
			$Timer.wait_time = float($Timer.wait_time) - 1;
		#should be lvl 1 = 4s   -> .1s currently is: 3.9 -> .1 at 19 and .1 at 20
		$Timer.start();
		if !(level > 15):
			$TextureProgress/Tween.interpolate_property($TextureProgress, "value", 0, 100, $Timer.wait_time);
			$TextureProgress/Tween.start();
		else:
			$TextureProgress.value = 0;
	if kind == Enums.Upgrade.CONTRACT:
		Globals.upgradeEnemyPool();
		target_enemy = Database.enemy_pool[level].enemy_pool.back()
		setContract()
	if(kind == Enums.Upgrade.ROLL_DECREASE):
		Globals.maxDiceRollTime = Globals.maxDiceRollTime - .2;
		$LabelTitle.text = title + " (" + str(Globals.maxDiceRollTime) + ")"; #TODO :show percentage instead of raw value
	if(kind == Enums.Upgrade.ASCEND):
		var _e = get_tree().change_scene("res://scenes/ascend.tscn");

func _on_Timer_timeout():
	if(kind == Enums.Upgrade.DUNGEON_MASTER):
		Globals.emit_signal("rollRandomDice")
		$TextureProgress.value = 0;
		if !(level > 15):
			$TextureProgress/Tween.interpolate_property($TextureProgress, "value", 0, 100, $Timer.wait_time);
			$TextureProgress/Tween.start();
	
func enemyDamaged(value: int, dice: Node2D):
	if(value <= level):
		dice.roll();
		
func setPayable(value):
	if(value >= price):
		$LabelPrice.add_color_override("font_color", Color("d8d400"));
	else:
		$LabelPrice.add_color_override("font_color", Color("d83300"));
		
func setImportedLevel(save_level):
	level = save_level;
	for i in save_level:
		price =+ calculatePriceIncrease(price,levelupPriceIncrease,levelupPricePercentIncrease);
	
	if kind == Enums.Upgrade.ADD_DICE || kind == Enums.Upgrade.UPGRADE_DICE:
		return
	
	if kind == Enums.Upgrade.CONTRACT:
		target_enemy = Database.enemy_pool[level].enemy_pool.back() 
		var t = bool(Save.importSave(Enums.SaveFlag.TARGET_ENEMY_BEATEN, 0))
		if t == false:
			setContract()
		for s in save_level:
			Globals.upgradeEnemyPool();
		return
		
	for s in save_level:
		action(); 
