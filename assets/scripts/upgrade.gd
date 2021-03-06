extends Control

enum Upgrade { ADD_DICE, UPGRADE_DICE, DUNGEON_MASTER, DICE_TOWER, REROLL, DICE_TRAY, CONTRACT };

onready var g = $"/root/Globals";

export var title: String = "Upgrade Name";
export var basePrice: int = 0;
export var levelupPriceIncrease: int = 10;
export var levelupPricePercentIncrease: int = 10;
export(Upgrade) var kind;
export var levelCap = -1;
#export var level: int = 0;
export(Texture) var spriteTexture;
export(String) var description;

var level = 0;
var price = 0;

func _ready():
	$LabelTitle.text = title;
	$Control/TextureRect.texture = spriteTexture;
	price = basePrice;
	updateUi();
	if(kind == 4):
		g.connect("damageEnemy", self, "enemyDamaged");
	
func updateUi():
	$LabelPrice.text = "$" + String(price);
	if(levelCap == -1):
		if(level > 0):
			$LabelLevel.text = String(level);
		else:
			$LabelLevel.text = "";
	else:
		if(level > 0):
			$LabelLevel.text = String(level) + "/" + String(levelCap);
		else:
			$LabelLevel.text = "";
		
func _on_MouseOverlay_button_down():
	if(g.currency < price):
		return;
	if(levelCap != -1):
		if(level >= levelCap):
			return;
	g.removeCurrency(price);
	level = level + 1;
	$CPUParticles2D.restart();
	$AudioStreamPlayer.play();
	
	price = price + levelupPriceIncrease;
	var priceIncrease: float = 0;
	if(levelupPricePercentIncrease != 0):
		priceIncrease = (float(price) / float(100)) * float(levelupPricePercentIncrease);
	price = price + ceil(priceIncrease);
	updateUi();
	action();
	
func action():
	if(kind == 0):
		g.addDice();
	if(kind == 1):
		g.upgradeDice();# BUGGED
	if(kind == 2):
		$Timer.stop();
		$Timer.wait_time = float($Timer.wait_time) - 1;
		$Timer.start();
	if(kind == 3):
		if($Timer.is_stopped()):
			$Timer.wait_time = 10;
			$Timer.start();
	if(kind == 6):
		# contract
		g.upgradeEnemyPool();
		pass
		

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
