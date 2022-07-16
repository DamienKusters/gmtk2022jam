extends Node2D

enum DiceEnum { D4, D6, D8, D10, D12, D20 };

const diceScene = preload("res://scenes/dice.tscn");

onready var spots = [
	$r1d1,$r1d2,$r1d3,$r1d4,$r1d5,$r1d6,$r1d7,
	$r2d1,$r2d2,$r2d3,$r2d4,$r2d5,$r2d6,$r2d7
];

var currentSpot = 0;

func _ready():
	addDice(0);
	addDice(1);
	addDice(2);
	addDice(3);
	addDice(4);
	addDice(5);
	pass

func addDice(type : int):
	var dice = diceScene.instance();
	dice.kind = type;
	dice.position = spots[currentSpot].position;
	$"../diceContainer".call_deferred("add_child", dice);
	currentSpot = currentSpot + 1;
	
