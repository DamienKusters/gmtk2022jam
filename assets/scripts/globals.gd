extends Node

enum DiceEnum { D4, D6, D8, D10, D12, D20 };

signal rollRandomDice;
signal damageEnemy;
signal currencyUpdated;

var currency = 0;

var enemiesCommon = [
	{
		"name":"Slime",
		"health":5,
		"currency":2,
		"time":8,
		"sprite": "res://assets/sprites/enemies/drentus cartoon.png"
	},
	{
		"name":"Goblin",
		"health":10,
		"currency":7,
		"time":10,
		"sprite": "res://assets/sprites/enemies/oranous cartoon.png"
	},
	{
		"name":"Wolf",
		"health":20,
		"currency":13,
		"time":18,
		"sprite": "res://assets/sprites/enemies/stepatus cartoon.png"
	},
];

func rollRandomDice():
	emit_signal("rollRandomDice");

func damageCurrentEnemy(value: int):
	emit_signal("damageEnemy", value);
	#rollRandomDice();#DEBUG REMOVE
	
func addCurrency(value: int):
	currency += value;
	emit_signal("currencyUpdated", currency);
