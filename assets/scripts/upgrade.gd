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
export(Enums.SaveFlag) var saveFlag
export var super_upgrade = false
export var help_index = -1
export var help_page = "upgrades"
var test_contract;
var target_enemy: EnemyModel

var level = 0;
var price = 0;

func _ready():
	$"%LabelTitle".text = title;
	$"%Icon".texture = spriteTexture;
	
	if super_upgrade:
		$bg.self_modulate = Color("6A4F76")
	
	price = basePrice;
	
	setImportedLevel(Save.importSave(saveFlag, 0))
	
	updateUi();
	if(kind == Enums.Upgrade.UPGRADE_DICE || kind == Enums.Upgrade.ENHANCE_DICE):
		var _a = Globals.connect("upgradeDiceSuccess", self, "applyNextLevelUiUpdate");
	if(kind == 4 || kind == Enums.Upgrade.SUPER_REROLL):
		updateUi();
		emit_signal("levelChanged");	
	if(kind == 6 || kind == Enums.Upgrade.HEXAGRAM):
		var _a = Globals.connect("enemyKilled", self, "enemyKilled");
		if level >= levelCap:
			locked = true
	var _a = Globals.connect("currencyUpdated", self, "setPayable");
	setPayable(Globals.currency);
	
	$Help.help_index = help_index
	$Help.help_page = help_page
	
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

func completeContract():
	locked = false
	$Tween.interpolate_property($bg, "rect_size", $bg.rect_size, Vector2(480,100), 1.5, Tween.TRANS_ELASTIC);
	$Tween.interpolate_property($bg, "rect_position", $bg.rect_position, Vector2(0,0), 1.5, Tween.TRANS_ELASTIC);
	$Tween.interpolate_property($enemyLocker/TextureRect, "rect_position", $enemyLocker/TextureRect.rect_position, Vector2(100,0), 1.5, Tween.TRANS_ELASTIC);
	$Tween.start();
	$"%LabelPrice".visible = true;
	Save.exportSave(Enums.SaveFlag.TARGET_ENEMY_BEATEN, 1)

func setContract():
	if level != levelCap:
		locked = true
		$enemyLocker/TextureRect.texture = target_enemy.sprite
		$Tween.interpolate_property($bg, "rect_size", $bg.rect_size, Vector2(380,100), 1.5, Tween.TRANS_ELASTIC);
		$Tween.interpolate_property($bg, "rect_position", $bg.rect_position, Vector2(100,0), 1.5, Tween.TRANS_ELASTIC);
		$Tween.interpolate_property($enemyLocker/TextureRect, "rect_position", $enemyLocker/TextureRect.rect_position, Vector2(0,0), 1.5, Tween.TRANS_ELASTIC);
		$Tween.start();
		$"%LabelPrice".visible = false;
		Save.exportSave(Enums.SaveFlag.TARGET_ENEMY_BEATEN, 0)
	else:
		updateUi()

func _on_MouseOverlay_button_down():
	if(locked == true):
		return;
	if(kind == 1 || kind == Enums.Upgrade.ENHANCE_DICE):# Quick fix for upgrade dice
		action();
	else:
		if(applyNextLevelUiUpdate(kind == Enums.Upgrade.ENHANCE_DICE)):
			action();
	Save.exportSave(saveFlag, level)
	Save.saveGame()

func enemyKilled(enemy):
	if locked == false || level == levelCap:
		return
	if(enemy.name == target_enemy.name):
		completeContract();

func applyNextLevelUiUpdate(enhanced):
	if !(enhanced == (kind == Enums.Upgrade.ENHANCE_DICE)):
		return
	
	if(Globals.currency < price):
		return false;
	if(levelCap != -1):
		if(level >= levelCap):
			return;
	Globals.removeCurrency(price);
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
		Globals.tryUpgradeDice(price, false);
	if(kind == Enums.Upgrade.ENHANCE_DICE):
		Globals.tryUpgradeDice(price, true);
	if(kind == Enums.Upgrade.DUNGEON_MASTER):
		if level == 1:
			$Timer.start()
		else:
			$Timer.stop()
			var tim = $Timer.wait_time
			if($Timer.wait_time <= 1):
				$Timer.wait_time = float($Timer.wait_time) - .1
			elif(tim <= 2):
				$Timer.wait_time = float($Timer.wait_time) - .2
			elif(tim <= 3):
				$Timer.wait_time = float($Timer.wait_time) - .3
			elif(tim <= 4):
				$Timer.wait_time = float($Timer.wait_time) - .4
			else:
				$Timer.wait_time = float($Timer.wait_time) - 1
			$Timer.start()
		if !(level > 15):
			$bg/TextureProgress/Tween.interpolate_property($bg/TextureProgress, "value", 0, 100, $Timer.wait_time);
			$bg/TextureProgress/Tween.start()
		else:
			$bg/TextureProgress.value = 0;
	if kind == Enums.Upgrade.CONTRACT:
		Globals.upgradeEnemyPool();
		target_enemy = Database.enemy_pool[level].enemy_pool.back()
		setContract()
	if kind == Enums.Upgrade.HEXAGRAM:
		Database.upgradeEnemyTier(level - 1)
		target_enemy = Database.enemy_pool[level - 1].enemy_pool.back()
		setContract()
	if(kind == Enums.Upgrade.ROLL_DECREASE):
		Globals.maxDiceRollTime = Globals.maxDiceRollTime - .2;
		$"%LabelTitle".text = title + " (-" + str(level * .2) + "s)"
	if kind == Enums.Upgrade.OVERDRIVE:
		Globals.maxDiceRollTime = Globals.maxDiceRollTime - .05
		Globals.minDiceRollTime = Globals.minDiceRollTime - .04
	if kind == Enums.Upgrade.SUPER_REROLL:
		$"%LabelTitle".text = title + " (≤" + str((level + 2) * 10) + ")"

func _on_Timer_timeout():
	if(kind == Enums.Upgrade.DUNGEON_MASTER):
		Globals.emit_signal("rollRandomDice")
		$bg/TextureProgress.value = 0;
		if !(level > 15):
			$bg/TextureProgress/Tween.interpolate_property($bg/TextureProgress, "value", 0, 100, $Timer.wait_time);
			$bg/TextureProgress/Tween.start();
	
func setPayable(value):
	if(value >= price):
		$"%LabelPrice".add_color_override("font_color", Color("d8d400"));
	else:
		$"%LabelPrice".add_color_override("font_color", Color("d83300"));
		
func setImportedLevel(save_level):
	if kind == Enums.Upgrade.REROLL:
		var x = Save.importSave(Enums.SaveFlag.A_REROLL_VALUE, 0)
		if x > save_level:
			save_level = x
			
	level = save_level;
	for i in save_level:
		price =+ calculatePriceIncrease(price,levelupPriceIncrease,levelupPricePercentIncrease);
		
	if kind == Enums.Upgrade.ADD_DICE || kind == Enums.Upgrade.UPGRADE_DICE || kind == Enums.Upgrade.ENHANCE_DICE:
		return
		
	if kind == Enums.Upgrade.CONTRACT:
		target_enemy = Database.enemy_pool[level].enemy_pool.back() 
		var t = bool(Save.importSave(Enums.SaveFlag.TARGET_ENEMY_BEATEN, 0))
		if t == false:
			setContract()
		for s in save_level:
			Globals.upgradeEnemyPool();
		return
	
	if kind == Enums.Upgrade.HEXAGRAM:
		target_enemy = Database.enemy_pool[level - 1].enemy_pool.back() 
		var t = bool(Save.importSave(Enums.SaveFlag.TARGET_ENEMY_BEATEN, 0))
		if t == false && level > 0:
			setContract()
		for s in save_level:
			Database.upgradeEnemyTier(s)
		return
		
	for s in save_level:
		action(); 

func shadowUpgradeSpawn():
	if super_upgrade:
		$CPUParticles2D.emitting = true
