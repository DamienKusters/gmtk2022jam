extends Node

enum DiceEnum { D4, D6, D8, D10, D12, D20 };

signal addDice;
signal upgradeDice;
signal rollRandomDice;
signal damageEnemy;
signal currencyUpdated;

var currency = 9999990;

var enemiesCommon = [
	{
		"name":"Slime",
		"health":5,
		"currency":7,
		"time":10,
		"sprite": "res://assets/sprites/enemies/drentus cartoon.png"
	},
	{
		"name":"Goblin",
		"health":10,
		"currency":15,
		"time":15,
		"sprite": "res://assets/sprites/enemies/oranous cartoon.png"
	},
	{
		"name":"Wolf",
		"health":20,
		"currency":23,
		"time":20,
		"sprite": "res://assets/sprites/enemies/stepatus cartoon.png"
	},
];

func addDice():
	emit_signal("addDice", 0);#0 = default
	
func upgradeDice():
	emit_signal("upgradeDice");

func rollRandomDice():
	emit_signal("rollRandomDice");

func damageCurrentEnemy(value: int):
	emit_signal("damageEnemy", value);
	#rollRandomDice();#DEBUG REMOVE
	
func addCurrency(value: int):
	currency += value;
	emit_signal("currencyUpdated", currency);
	
func removeCurrency(value: int):
	currency -= value;
	emit_signal("currencyUpdated", currency);
