extends Node

enum DiceEnum { D4, D6, D8, D10, D12, D20 };

signal addDice;
signal upgradeDice;
signal upgradeDiceSuccess;
signal rollRandomDice;
signal damageEnemy;
signal currencyUpdated;
signal feathersUpdated;
signal currencyAddedSingular;
signal openHelp;
signal enemyKilled;

var enemyPool = 4;
var maxDiceRollTime = 4;
var currency = 9999;
var feathers = 90;

#TODO: Ascention upgrades:
var ascention_dps_multiplier = 1;
var ascention_reroller = 0;

var rng = RandomNumberGenerator.new();

func reset():
#	currency = 0;
	feathers = 0;
	enemyPool = 4;
	maxDiceRollTime = 4;

func addDice():
	emit_signal("addDice", 0);#0 = default
	
func tryUpgradeDice(price):
	if(currency < price):
		return;
	emit_signal("upgradeDice");
	
func upgradeDiceSuccess():
	emit_signal("upgradeDiceSuccess");

func rollRandomDice():
	emit_signal("rollRandomDice");

func damageCurrentEnemy(value: int, dice: Node2D):
	emit_signal("damageEnemy", value, dice);
	
func upgradeEnemyPool():
	enemyPool += 4;
	
func killEnemy(enemy):
	emit_signal("enemyKilled", enemy);
	
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
	emit_signal("currencyAddedSingular", value);
	
func removeCurrency(value: int):
	currency -= value;
	emit_signal("currencyUpdated", currency);

func addFeathers(value: int):
	feathers += value;
	emit_signal("feathersUpdated", feathers);

func removeFeathers(value: int):
	feathers -= value;
	emit_signal("feathersUpdated", feathers);

var enemiesCommon = [
	#Tier 1: Basic
	{
		"name":"Slime",
		"health":3,
		"currency":5,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Slime.png",
		"feather":0
	},
	{
		"name":"Bird",
		"health":4,
		"currency":7,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Bird.png",
		"feather":0
	},
	{
		"name":"Wolf",
		"health":5,
		"currency":10,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Wolf.png",
		"feather":0
	},
	{
		"name":"Goblin",
		"health":7,
		"currency":15,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Regular_Goblin.png",
		"feather":0
	},
	#Tier 2: Advanced
	{
		"name":"Cobalt Wolf",
		"health":26,
		"currency":50,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Cobald_Wolf.png",
		"feather":0
	},
	{
		"name":"Elite Goblin",
		"health":26,
		"currency":60,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Elite_Goblin.png",
		"feather":0
	},
	{
		"name":"Bandit",
		"health":30,
		"currency":70,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Pirate.png",
		"feather":0
	},
	{
		"name":"Outlaw",
		"health":30,
		"currency":70,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Bandit.png",
		"feather":0
	},
	#Tier 3: Mytical (TODO: add 60% health) 
	{
		"name":"Witch",
		"health":60,
		"currency":80,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Witch.png",
		"feather":0
	},
	{
		"name":"Gaia",
		"health":80,
		"currency":100,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Gaia.png",
		"feather":0
	},
	{
		"name":"Minotaur",
		"health":90,
		"currency":90,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Minotaur.png",
		"feather":0
	},
	{
		"name":"Golem",
		"health":190,
		"currency":150,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Nature_Gorilla.png",
		"feather":0
	},
	#Tier 4: Magic (TODO: triple health (except boss))
	{
		"name":"Pixie",
		"health":250,
		"currency":111,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Earth_Lady.png",
		"feather":0
	},
	{
		"name":"Pixie",
		"health":280,
		"currency":111,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Pixie_Man.png",
		"feather":0
	},
	{
		"name":"Wrath",
		"health":340,
		"currency":100,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Wtf.png",
		"feather":0
	},
	{
		"name":"Necromancer",
		"health":400,
		"currency":444,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Necromancer.png",
		"feather":1
	},
	#Tier 5: Demons (TODO: triple/quadruple health)
#	{
#		"name":"Fire Demon",
#		"health":26,
#		"currency":30,
#		"time":10,
#		"sprite": "res://assets/sprites/enemies/Salamander.png"
#	},
	{
		"name":"Lich",
		"health":500,
		"currency":106,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Lich.png",
		"feather":0
	},
	{
		"name":"Demon Pixie",
		"health":620,
		"currency":110,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Earth_Lady_Vampire.png",
		"feather":0
	},
	{
		"name":"Demon Pixie",
		"health":650,
		"currency":110,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Pixie_Man_Vampire.png",
		"feather":0
	},
	{
		"name":"Demon Lord",
		"health":1200,
		"currency":666,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Demon.png",
		"feather":1
	},
	#Tier 6: Elementals (TODO: health x8)
	{
		"name":"Earth Elemental",
		"health":4000,
		"currency":999,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Earth_Elemental.png",
		"feather":0
	},
	{
		"name":"Fire Elemental",
		"health":4000,
		"currency":999,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Fire_Elemental.png",
		"feather":0
	},
	{
		"name":"Power Elemental",
		"health":4000,
		"currency":999,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Volt_Elemental.png",
		"feather":0
	},
	{
		"name":"Water Elemental",
		"health":4000,
		"currency":999,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Water_Elemental.png",
		"feather":0
	},
	# Tier 7: Legendary (TODO: Health x8-10)
	{
		"name":"Darkness",
		"health":5500,
		"currency":0,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Darkness.png",
		"feather":1
	},
	{
		"name":"Light",
		"health":5500,
		"currency":0,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Light.png",
		"feather":1
	},
	{#Must be special, rare enemy, drops angel feathers
		"name":"Angel",
		"health":10000,
		"currency":0,
		"time":10,
		"sprite": "res://assets/sprites/enemies/Angel.png",
		"feather":-1
	},
	#Okay, dus: angel drops angel feathers, each feather makes you roll a 'prime dice'
	# You can ascend deleting progress but you can purchase:
	# options of dice:
	#	DPS multiplier: d4 -> each roll stacks
	#	Reroller starting level?
#	Choose mountain map (more feathers, more challenge)
# Also, dice tower is too powerful, must become more expensive
#	Well everything must be more expensive to make up for the angel feathers
#	Killing demon lord for the first time = 1 demon feather (you can ascend with that) (afterwards it is just 666 money)
# demon feather unlocks new special ascend upgrade, you can upgrade it with angel feathers, and if you cant upgrade, you
# get the option to ascend with x amount of rolls based on level (default roll = 1)  
# reroller as ascention upgrade?
#
#
#
# TODO:
#	Ascention screen
#	- Reroll dice always 1 feather
#	- Scale cost of upgrade dice with % of increase
#		Example:
#		rest = D6 - D4
#		D4 = 100% + rest = ???%
#
#
	# Tier 8: Future
#	{
#		"name":"Destroyer",
#		"health":550,
#		"currency":400,
#		"time":10,
#		"sprite": "res://assets/sprites/enemies/DestroyerV1.png"
#	},
#	{
#		"name":"Destroyer MRK 2",
#		"health":550,
#		"currency":400,
#		"time":10,
#		"sprite": "res://assets/sprites/enemies/DestroyerV2.png"
#	},
];
