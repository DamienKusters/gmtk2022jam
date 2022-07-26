extends Node

enum DiceEnum { D4, D6, D8, D10, D12, D20 };

signal addDice;
signal upgradeDice;
signal rollRandomDice;
signal damageEnemy;
signal currencyUpdated;
signal openHelp;

var enemyPool = 4;
var currency = 9999990;

var rng = RandomNumberGenerator.new();

func addDice():
	emit_signal("addDice", 0);#0 = default
	
func upgradeDice():
	emit_signal("upgradeDice");

func rollRandomDice():
	emit_signal("rollRandomDice");

func damageCurrentEnemy(value: int, dice: Node2D):
	emit_signal("damageEnemy", value, dice);
	
func upgradeEnemyPool():
	enemyPool += 4;
	
func openHelp(txt: Texture, title: String, description: String):
	var obj = {
		"texture": txt,
		"title": title,
		"description": description
	};
	emit_signal("openHelp", obj);
	
func getEnemyFromPool():
	var size = enemyPool;
	
	if(enemyPool > enemiesCommon.size()):
		size = enemiesCommon.size();
	
	rng.randomize();
	var idx = rng.randi_range(0, size -1);
	return enemiesCommon[idx];
	
func addCurrency(value: int):
	currency += value;
	emit_signal("currencyUpdated", currency);
	
func removeCurrency(value: int):
	currency -= value;
	emit_signal("currencyUpdated", currency);

var enemiesCommon = [
	#Tier 1
	{
		"name":"Slime",
		"health":3,
		"currency":3,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Slime.png"
	},
	{
		"name":"Bird",
		"health":6,
		"currency":8,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Bird.png"
	},
	{
		"name":"Wolf",
		"health":10,
		"currency":12,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Wolf.png"
	},
	{
		"name":"Goblin",
		"health":17,
		"currency":18,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Regular_Goblin.png"
	},
	#Tier 2
	{
		"name":"Witch",
		"health":20,
		"currency":24,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Witch.png"
	},
	{
		"name":"Cobalt Wolf",
		"health":26,
		"currency":30,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Cobald_Wolf.png"
	},
	{
		"name":"Elite Goblin",
		"health":26,
		"currency":40,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Elite_Goblin.png"
	},
	{
		"name":"Bandit",
		"health":30,
		"currency":35,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Pirate.png"
	},
#	{#TODO
#		"name":"Outlaw",
#		"health":30,
#		"currency":35,
#		"time":10,
#		"sprite": "res://assets/sprites/enemies/Outlaw.png"
#	},
	#Tier 3
	{
		"name":"Gaia",
		"health":40,
		"currency":35,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Gaia.png"
	},
	{
		"name":"Fire Feline",
		"health":26,
		"currency":30,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Salamander.png"
	},
	{
		"name":"Minotaur",
		"health":37,
		"currency":40,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Minotaur.png"
	},
	{
		"name":"Golem",
		"health":55,
		"currency":50,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Nature_Gorilla.png"
	},
	#Tier 4
	{
		"name":"Pixie",
		"health":40,
		"currency":58,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Earth_Lady.png"
	},
	{
		"name":"Pixie",
		"health":45,
		"currency":62,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Pixie_Man.png"
	},
	{
		"name":"Wrath",
		"health":55,
		"currency":70,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Wtf.png"
	},
	{
		"name":"Lich",
		"health":66,
		"currency":66,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Lich.png"
	},
	#Tier 5
	#Tier 6
	{
		"name":"Necromancer",
		"health":400,
		"currency":350,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Necromancer.png"
	},
	{
		"name":"Demon Lord",
		"health":550,
		"currency":400,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Demon.png"
	},
];
