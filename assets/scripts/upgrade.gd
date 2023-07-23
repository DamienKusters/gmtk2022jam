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
var test_contract;
var lockedEnemies = {
	"Slime":[false, "res://assets/sprites/enemies/Slime.png"],
	"Boar":[false, "res://assets/sprites/enemies/WildBoar.png"],
	"Orc":[false, "res://assets/sprites/enemies/Orc.png"],
	"Golem":[false, "res://assets/sprites/enemies/Nature_Gorilla.png"],
	"Minotaur":[false, "res://assets/sprites/enemies/Minotaur.png"],
	"Nymph":[false, "res://assets/sprites/enemies/Earth_Lady.png"],
	"Necromancer":[false, "res://assets/sprites/enemies/Necromancer.png"],
	"Power Elemental":[false, "res://assets/sprites/enemies/Volt_Elemental.png"],
	"Darkness":[false, "res://assets/sprites/enemies/Darkness.png"],
};
#var oldlockedEnemies = {
#	"Goblin":[false, "res://assets/sprites/enemies/Regular_Goblin.png"],
#	"Bandit":[false, "res://assets/sprites/enemies/Bandit.png"],
#	"Golem":[false, "res://assets/sprites/enemies/Nature_Gorilla.png"],
#	"Necromancer":[false, "res://assets/sprites/enemies/Necromancer.png"],
#	"Demon Lord":[false, "res://assets/sprites/enemies/Demon.png"],
#	"Power Elemental":[false, "res://assets/sprites/enemies/Volt_Elemental.png"],
#};
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
		Globals.connect("upgradeDiceSuccess", self, "applyNextLevelUiUpdate");
	if(kind == 4):
		if Globals.upgrade_save_overrides == null:
			level = Globals.ascention_reroller_value;
			for i in level:
				price =+ calculatePriceIncrease(price,levelupPriceIncrease,levelupPricePercentIncrease);
		updateUi();
		Globals.connect("damageEnemy", self, "enemyDamaged");
		emit_signal("levelChanged");	
	if(kind == 6):
		Globals.connect("enemyKilled", self, "enemyKilled");
		var _e = $Tween.connect("tween_all_completed", self, "tween_completed");
		locked = level < levelCap;
		$enemyLocker.visible = false;
		setContract();
	$enemyLocker.visible = false;
	Globals.connect("currencyUpdated", self, "setPayable");
	setPayable(Globals.currency);
	if kind == Enums.Upgrade.ASCEND:
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

func completeContract():
	locked = false
	$Tween.interpolate_property(self, "margin_left", self.margin_left, 0, 1.5, Tween.TRANS_ELASTIC);
	$Tween.start();
	$enemyLocker.visible = false;
	$LabelPrice.visible = true;

func setContract():
	if level != levelCap:
		locked = true
		$Tween.interpolate_property(self, "margin_left", self.margin_left, 100, 1.5, Tween.TRANS_ELASTIC);
		$Tween.start();
		$LabelPrice.visible = false;
	else:
		updateUi()

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
					completeContract();
					lockedEnemies[e][0] = true;
				return;
		killedEnemies.push_back(enemy.name);

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
		Globals.addDice();
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
		$Timer.start();
		if !(level > 15):
			$TextureProgress/Tween.interpolate_property($TextureProgress, "value", 0, 100, $Timer.wait_time);
			$TextureProgress/Tween.start();
		else:
			$TextureProgress.value = 0;
	if kind == Enums.Upgrade.CONTRACT:
		Globals.upgradeEnemyPool();
		for e in lockedEnemies:
			if(lockedEnemies[e][0] == false):
				setContract();
				return;
		pass
	if(kind == Enums.Upgrade.ROLL_DECREASE):
		Globals.maxDiceRollTime = Globals.maxDiceRollTime - .2;
		$LabelTitle.text = title + " (" + str(Globals.maxDiceRollTime) + ")"; #TODO :show percentage instead of raw value
	if(kind == 8):
		#TODO:animation
		var _e = get_tree().change_scene("res://scenes/ascend.tscn");

func _on_Timer_timeout():
	if(kind == 2):
		Globals.rollRandomDice();
		$TextureProgress.value = 0;
		if !(level > 15):
			$TextureProgress/Tween.interpolate_property($TextureProgress, "value", 0, 100, $Timer.wait_time);
			$TextureProgress/Tween.start();
	if(kind == 3):
		for i in level:
			Globals.rollRandomDice();
	
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
		Enums.Upgrade.ADD_DICE:
			var save_level = int(save[0]);
			setImportedLevel(save_level);
			# This upgrade is restored differently
		Enums.Upgrade.UPGRADE_DICE:
			var save_level = int(save[1]);
			setImportedLevel(save_level);
			# This upgrade is restored differently
		Enums.Upgrade.DUNGEON_MASTER:
			var save_level = int(save[2]);
			setImportedLevel(save_level);
			for s in save_level:
				action();
		Enums.Upgrade.REROLL:
			var save_level = int(save[4]);
			setImportedLevel(save_level);
			for s in save_level:
				action();
		Enums.Upgrade.CONTRACT:
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
		Enums.Upgrade.ROLL_DECREASE:
			var save_level = int(save[3]);
			setImportedLevel(save_level);
			for s in save_level:
				action();
	pass
	
func setImportedLevel(save_level):
	level = save_level;
	for i in save_level:
		price =+ calculatePriceIncrease(price,levelupPriceIncrease,levelupPricePercentIncrease);
