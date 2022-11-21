extends Control

enum Upgrade { ADD_DICE, UPGRADE_DICE, DUNGEON_MASTER, DICE_TOWER, REROLL, DICE_TRAY, CONTRACT, ROLL_DECREASE, ASCEND };

onready var g = $"/root/Globals";

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
	updateUi();
	if(kind == 1):
		g.connect("upgradeDiceSuccess", self, "applyNextLevelUiUpdate");
	if(kind == 4):
		level = g.ascention_reroller;
		updateUi();
		g.connect("damageEnemy", self, "enemyDamaged");
	if(kind == 6):
		g.connect("enemyKilled", self, "enemyKilled");
		$Tween.connect("tween_all_completed", self, "tween_completed");
	g.connect("currencyUpdated", self, "setPayable");
	setPayable(0);
	$enemyLocker.visible = false;
	setLocked(locked);
	if kind == Upgrade.ASCEND:
		$TextureRect.self_modulate = Color('563eff');
	
func updateUi():
	$LabelPrice.text = "" + String(price);
#	if(levelCap == -1):
	if(level == levelCap):
		$LabelLevel.text = "max";
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
	$CPUParticles2D.restart();
	$AudioStreamPlayer.play();
	if(levelCap != -1):
		if(level >= levelCap):
			$LabelPrice.visible = false;
	
	price = price + levelupPriceIncrease;
	var priceIncrease: float = 0;
	if(levelupPricePercentIncrease != 0):
		priceIncrease = (float(price) / float(100)) * float(levelupPricePercentIncrease);
	price = price + ceil(priceIncrease);
	updateUi();
	setPayable(g.currency);
	return true;
	
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
	if(kind == 3):#Removed
		if($Timer.is_stopped()):
			$Timer.wait_time = 10;
			$Timer.start();
	if(kind == 6):
		# contract
		g.upgradeEnemyPool();
		for e in lockedEnemies:
			if(lockedEnemies[e][0] == false):
				setLocked(true);
				return;
		pass
	if(kind == 7):
		g.maxDiceRollTime = g.maxDiceRollTime - .4;
	if(kind == 8):
		var e = get_tree().change_scene("res://scenes/ascend.tscn");

func _on_Timer_timeout():
	if(kind == 2):
		g.rollRandomDice();
	if(kind == 3):
		for i in level:
			g.rollRandomDice();
	pass # Replace with function body.
	
func enemyDamaged(value: int, dice: Node2D):
	if(value <= level):
		dice.roll();
		
func setPayable(value):
	if(value >= price):
		$LabelPrice.add_color_override("font_color", Color("d8d400"));
	else:
		$LabelPrice.add_color_override("font_color", Color("d83300"));
		
