extends Control

signal levelChanged;

enum Upgrade { ADD_DICE, UPGRADE_DICE, DUNGEON_MASTER, DICE_TOWER, REROLL, DICE_TRAY, CONTRACT, ROLL_DECREASE, ASCEND };

onready var g = $"/root/Globals";
onready var particle = preload("res://scenes/shared/single_particle_effect.tscn");

export var locked = false;
export var title: String = "Upgrade Name";
export var basePrice: int = 0;
export var levelupPriceIncrease: int = 10;
export var levelupPricePercentIncrease: int = 10;
export(Upgrade) var kind;
export var levelCap = -1;
#export var level: int = 0;
export(Texture) var spriteTexture;
export(String) var description;
var lockedEnemies = {
	"Goblin":[false, "res://assets/sprites/enemies/Regular_Goblin.png"],
	"Outlaw":[false, "res://assets/sprites/enemies/Bandit.png"],
	"Golem":[false, "res://assets/sprites/enemies/Nature_Gorilla.png"],
	"Necromancer":[false, "res://assets/sprites/enemies/Necromancer.png"],
	"Demon Lord":[false, "res://assets/sprites/enemies/Demon.png"],
	"Power Elemental":[false, "res://assets/sprites/enemies/Volt_Elemental.png"],
};
var killedEnemies = [];

var level = 0;
var price = 0;

func _ready():
	$LabelTitle.text = title;
	$Control/TextureRect.texture = spriteTexture;
	
	price = basePrice;
	
	if Globals.upgrade_save_overrides != null:
		importSave(Globals.upgrade_save_overrides);
	
	updateUi();
	if(kind == 1):
		g.connect("upgradeDiceSuccess", self, "applyNextLevelUiUpdate");
	if(kind == 4):
		if Globals.upgrade_save_overrides == null:
			level = g.ascention_reroller_value;
			for i in level:
				price =+ calculatePriceIncrease(price,levelupPriceIncrease,levelupPricePercentIncrease);
		updateUi();
		g.connect("damageEnemy", self, "enemyDamaged");
		emit_signal("levelChanged");	
	if(kind == 6):
		g.connect("enemyKilled", self, "enemyKilled");
		var _e = $Tween.connect("tween_all_completed", self, "tween_completed");
		locked = level < levelCap;
	g.connect("currencyUpdated", self, "setPayable");
	setPayable(g.currency);
	$enemyLocker.visible = false;
	setLocked(locked);
	if kind == Upgrade.ASCEND:
		$TextureRect.self_modulate = Color('f2ff56');
	
func updateUi():
	$LabelPrice.text = String(price);
#	if(levelCap == -1):
	if(level == levelCap):
		$LabelLevel.text = "max";
		$LabelPrice.text = "";
	elif(level > 0):
		$LabelLevel.text = String(level);
	else:
		$LabelLevel.text = "";
#	else:
#		if(level > 0):
#			$LabelLevel.text = String(level) + "/" + String(levelCap);
#		else:
#			$LabelLevel.text = "";

func setLocked(value):
	locked = value;
	if(locked):
		$Tween.interpolate_property(self, "margin_left", self.margin_left, 100, 1.5, Tween.TRANS_ELASTIC);
		$Tween.start();
		$LabelPrice.visible = false;
	else:
		$Tween.interpolate_property(self, "margin_left", self.margin_left, 0, 1.5, Tween.TRANS_ELASTIC);
		$Tween.start();
		$enemyLocker.visible = false;
		$LabelPrice.visible = true;
		
func tween_completed():
	if(locked):
		$enemyLocker.visible = true;
		for e in lockedEnemies:
			if lockedEnemies[e][0] == false:
				$enemyLocker/TextureRect.texture = load(lockedEnemies[e][1]);
				return;
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
	Globals.saveGame();
			
func enemyKilled(enemy):
	if(!killedEnemies.has(enemy.name)):
		for e in lockedEnemies:
			if lockedEnemies[e][0] == false:
				if(enemy.name == e):
					setLocked(false);
					lockedEnemies[e][0] = true;
				return;
		killedEnemies.push_back(enemy.name);
	
func applyNextLevelUiUpdate():
	if(g.currency < price):
		return false;
	if(levelCap != -1):
		if(level >= levelCap):
			return;
	g.removeCurrency(price);
	level = level + 1;
#	$CPUParticles2D.restart();
	var p = particle.instance();
	p.position = $particle_point.position;
	add_child(particle.instance());
	$AudioStreamPlayer.play();
	if(levelCap != -1):
		if(level >= levelCap):
			$LabelPrice.visible = false;
	
	price =+ calculatePriceIncrease(price,levelupPriceIncrease,levelupPricePercentIncrease);
	updateUi();
	setPayable(g.currency);
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
	if(kind == 0):
		g.addDice();
	if(kind == 1):
		g.tryUpgradeDice(price);
	if(kind == 2):
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
		$Timer.start();
		if !(level > 15):
			$TextureProgress/Tween.interpolate_property($TextureProgress, "value", 0, 100, $Timer.wait_time);
			$TextureProgress/Tween.start();
		else:
			$TextureProgress.value = 0;
	if(kind == 6):
		# contract
		g.upgradeEnemyPool();
		for e in lockedEnemies:
			if(lockedEnemies[e][0] == false):
				setLocked(true);
				return;
		pass
	if(kind == 7):
		g.maxDiceRollTime = g.maxDiceRollTime - .35;
		$LabelTitle.text = title + " (" + str(g.maxDiceRollTime) + ")";
	if(kind == 8):
		var _e = get_tree().change_scene("res://scenes/ascend.tscn");

func _on_Timer_timeout():
	if(kind == 2):
		g.rollRandomDice();
		$TextureProgress.value = 0;
		if !(level > 15):
			$TextureProgress/Tween.interpolate_property($TextureProgress, "value", 0, 100, $Timer.wait_time);
			$TextureProgress/Tween.start();
	if(kind == 3):
		for i in level:
			g.rollRandomDice();
	
func enemyDamaged(value: int, dice: Node2D):
	if(value <= level):
		dice.roll();
		
func setPayable(value):
	if(value >= price):
		$LabelPrice.add_color_override("font_color", Color("d8d400"));
	else:
		$LabelPrice.add_color_override("font_color", Color("d83300"));
		
func exportSave():
	return str(level);

func importSave(saveString):
	var save = saveString.split("/");
	match kind:
		0:#Add Dice
			var save_level = int(save[0]);
			setImportedLevel(save_level);
			# This upgrade is restored differently
		1:#Upgrade Dice
			var save_level = int(save[1]);
			setImportedLevel(save_level);
			# This upgrade is restored differently
		2:#DM
			var save_level = int(save[2]);
			setImportedLevel(save_level);
			for s in save_level:
				action();
		4:#Reroll
			var save_level = int(save[4]);
			setImportedLevel(save_level);
			for s in save_level:
				action();
		6:#Contract
			var save_level = int(save[5]);
			setImportedLevel(save_level);
			for s in save_level:
				action();
			#TODO: restore enemy locks:
			var i = 0;
			for l in lockedEnemies:
				if save_level > i:
					lockedEnemies[l][0] = true;
					print(l);
				i+=1;
#				if lockedEnemies[e][0] == false:
#					if(enemy.name == e):
#						setLocked(false);
#						lockedEnemies[e][0] = true;
#					return;
		7:#Roll decrease
			var save_level = int(save[3]);
			setImportedLevel(save_level);
			for s in save_level:
				action();
	pass
	
func setImportedLevel(save_level):
	level = save_level;
	for i in save_level:
		price =+ calculatePriceIncrease(price,levelupPriceIncrease,levelupPricePercentIncrease);
