extends Node2D

onready var g = $"/root/Globals";

enum DiceEnum { D4, D6, D8, D10, D12, D20 };

const diceScene = preload("res://scenes/dice.tscn");

onready var spots = [
	$r1d1,$r1d2,$r1d3,$r1d4,$r1d5,$r1d6,$r1d7,
	$r2d1,$r2d2,$r2d3,$r2d4,$r2d5,$r2d6,$r2d7,
	$r3d1,$r3d2,$r3d3,$r3d4,$r3d5,$r3d6,$r3d7
];

var currentSpot = 0;

func _ready():
	g.connect("addDice", self, "addDice");
	
	if Globals.upgrade_dice_overrides == null:
		Globals.upgradeDiceOverridesUpdated("0");
	
	#TODO: Different save string: 21 spots with values (D4-D20) restore accordingly
	if Globals.upgrade_save_overrides != null:
		var initDice = int(Globals.upgrade_save_overrides.split("/")[0]);
		var diceLevels = Globals.upgrade_dice_overrides.split("/");
		for d in initDice+1:
			if(d < diceLevels.size()):
				addDice(int(diceLevels[d]));
			else:
				addDice(0);
	$"../diceContainer".exportAllSaves();
	pass

func addDice(type):
	if(currentSpot == 21):
		return;
	var dice = diceScene.instance();
	dice.kind = type;
	dice.position = spots[currentSpot].position;
	$"../diceContainer".call_deferred("add_dice", dice);
	currentSpot = currentSpot + 1;
