extends Node

onready var game = "res://scenes/main.tscn";

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

var saveFileLocation = "user://dnde.save"
var enemyPool = 4;
var maxDiceRollTime = 4.5;
var currency = 0;
var feathers = 0;

var upgrade_save_overrides;
var upgrade_dice_overrides;
var enemy_exclusive_feathers_overrides;

var ascention_dps_multiplier_value = 1;
var ascention_dps_multiplier_level = 0;
var ascention_reroller_value = 0;
var ascention_reroller_level = 0;

var options_music = 1;
var options_sound = 2;

var rng = RandomNumberGenerator.new();

var diceData = {
	0:{
		"value": 4,
		"texture": "res://assets/sprites/dice/d4.png",
		"color": Color(0.098, 0.639, 0.259)
	},
	1:{
		"value": 6,
		"texture": "res://assets/sprites/dice/d6.png",
		"color": Color(0.114, 0.753, 0.827)
	},
	2:{
		"value": 8,
		"texture": "res://assets/sprites/dice/d8.png",
		"color": Color(0.592, 0.231, 0.89)
	},
	3:{
		"value": 10,
		"texture": "res://assets/sprites/dice/d10.png",
		"color": Color(0.89, 0.169, 0.588)
	},
	4:{
		"value": 12,
		"texture": "res://assets/sprites/dice/d12.png",
		"color": Color(0.859, 0.235, 0.255)
	},
	5:{
		"value": 20,
		"texture": "res://assets/sprites/dice/d20.png",
		"color": Color(0.953, 0.502, 0)
	}
};

func ascendReset():
	upgrade_save_overrides = null;
	upgrade_dice_overrides = null;
	currency = 10 * feathers;
	feathers = 0;
	enemyPool = 4;
	maxDiceRollTime = 4.5;
	restoreEnemyFeathers();

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
		"health":4,
		"currency":5,
		"sprite": "res://assets/sprites/enemies/Slime.png",
		"feather":0,
		"shield":null,#TODO: array
	},
	{
		"name":"Bird",
		"health":6,
		"currency":7,
		"sprite": "res://assets/sprites/enemies/Bird.png",
		"feather":0,
		"shield":null,
	},
	#SWAP ENEMY: BAT
	{
		"name":"Wolf",
		"health":9,
		"currency":10,
		"sprite": "res://assets/sprites/enemies/Wolf.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Goblin",
		"health":25,
		"currency":20,
		"sprite": "res://assets/sprites/enemies/Regular_Goblin.png",
		"feather":0,
		"shield":null,
	},
	#Tier 2: Advanced
	{
		"name":"Cobalt Wolf",
		"health":26,
		"currency":50,
		"sprite": "res://assets/sprites/enemies/Cobald_Wolf.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Elite Goblin",
		"health":30,
		"currency":60,
		"sprite": "res://assets/sprites/enemies/Elite_Goblin.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Bandit",
		"health":35,
		"currency":70,
		"sprite": "res://assets/sprites/enemies/Pirate.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Outlaw",
		"health":55,
		"currency":70,
		"sprite": "res://assets/sprites/enemies/Bandit.png",
		"feather":0,
		"shield":null,
	},
	#Tier 3: Mytical
	{
		"name":"Witch",
		"health":65,
		"currency":100,
		"sprite": "res://assets/sprites/enemies/Witch.png",
		"feather":0,
		"shield":null,
	},
	# new tier between 3 & 4
	#ENEMY: AnimatedPlant tier 3
	#ENEMY: Treant tier 3
	#ENEMY: BanditNew NEW tier 4
	#ENEMY: Bat tier 1
	#ENEMY: Fairy tier 5
	#ENEMY: Hornet tier 2
	#ENEMY: Rat tier 2
	#ENEMY: HobGoblin NEW tier 4
	#ENEMY: Ogre (troll) NEW TIER tier 4
	#ENEMY: Orc NEW TIER 4
	#ENEMY: skeleton Tier 6 (demons)
	#ENEMY: slug tier 2
	#ENEMY: Boar tier 3
	#ENEMY: Wizard tier 7
	{
		"name":"Gaia",
		"health":95,
		"currency":111,
		"sprite": "res://assets/sprites/enemies/Gaia.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Minotaur",
		"health":120,
		"currency":150,
		"sprite": "res://assets/sprites/enemies/Minotaur.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Golem",
		"health":190,
		"currency":200,
		"sprite": "res://assets/sprites/enemies/Nature_Gorilla.png",
		"feather":0,
		"shield":DiceEnum.D4,
	},
	#Tier 4: Magic
	{
		"name":"Pixie",
		"health":250,
		"currency":200,
		"sprite": "res://assets/sprites/enemies/Earth_Lady.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Fairy",
		"health":290,
		"currency":250,
		"sprite": "res://assets/sprites/enemies/Pixie_Man.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Wrath",
		"health":320,
		"currency":290,
		"sprite": "res://assets/sprites/enemies/Wtf.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Necromancer",
		"health":430,
		"currency":444,
		"sprite": "res://assets/sprites/enemies/Necromancer.png",
		"feather":1,
		"shield":DiceEnum.D6,
	},
	#Tier 5: Demons
	{
		"name":"Demon Pixie",
		"health":620,
		"currency":500,
		"sprite": "res://assets/sprites/enemies/Earth_Lady_Vampire.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Demon Fairy",
		"health":650,
		"currency":550,
		"sprite": "res://assets/sprites/enemies/Pixie_Man_Vampire.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Lich",
		"health":800,
		"currency":600,
		"sprite": "res://assets/sprites/enemies/Lich.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Demon Lord",
		"health":1200,
		"currency":666,
		"sprite": "res://assets/sprites/enemies/Demon.png",
		"feather":1,
		"shield":DiceEnum.D8,
	},
	#Tier 6: Elementals (TODO: health x8)
	{
		"name":"Earth Elemental",
		"health":2000,
		"currency":800,
		"sprite": "res://assets/sprites/enemies/Earth_Elemental.png",
		"feather":0,
		"shield":DiceEnum.D10,
	},
	{
		"name":"Fire Elemental",
		"health":3000,
		"currency":900,
		"sprite": "res://assets/sprites/enemies/Fire_Elemental.png",
		"feather":0,
		"shield":DiceEnum.D12,
	},
	{
		"name":"Power Elemental",
		"health":5000,
		"currency":1100,
		"sprite": "res://assets/sprites/enemies/Volt_Elemental.png",
		"feather":0,
		"shield":DiceEnum.D10,
	},
	{
		"name":"Water Elemental",
		"health":4000,
		"currency":1000,
		"sprite": "res://assets/sprites/enemies/Water_Elemental.png",
		"feather":0,
		"shield":DiceEnum.D12,
	},
	# Tier 7: Legendary
	{
		"name":"Darkness",
		"health":8500,
		"currency":1111,
		"sprite": "res://assets/sprites/enemies/Darkness.png",
		"feather":1,
		"shield":DiceEnum.D10,
	},
	{
		"name":"Light",
		"health":8500,
		"currency":1111,
		"sprite": "res://assets/sprites/enemies/Light.png",
		"feather":1,
		"shield":DiceEnum.D12,
	},
	{#Special
		"name":"Angel",
		"health":10000,
		"currency":0,
		"sprite": "res://assets/sprites/enemies/Angel.png",
		"feather":-1,
		"shield":null,
	},
	# Tier 8: Future
#	{
#		"name":"Destroyer",
#		"health":550,
#		"currency":400,
#		
#		"sprite": "res://assets/sprites/enemies/DestroyerV1.png"
#	},
#	{
#		"name":"Destroyer MRK 2",
#		"health":550,
#		"currency":400,
#		
#		"sprite": "res://assets/sprites/enemies/DestroyerV2.png"
#	},
];

func restoreEnemyFeathers():
	#The spaghetti is getting unreal, I hope I can release this soon.
	enemiesCommon[15]['feather'] = 1;
	enemiesCommon[19]['feather'] = 1;
	enemiesCommon[24]['feather'] = 1;
	enemiesCommon[25]['feather'] = 1;
	enemy_exclusive_feathers_overrides = "";

func getDiceData(enumValue):
	return diceData[int(enumValue)];
	
func upgradeSavesUpdated(save):
	upgrade_save_overrides = save;
	
func upgradeDiceOverridesUpdated(save):
	upgrade_dice_overrides = save;

var saveResources = [];

func exportSave():

	saveResources = [
		currency,
		feathers,
		upgrade_save_overrides,
		str(ascention_dps_multiplier_value) + "/" + str(ascention_dps_multiplier_level),
		str(ascention_reroller_value) + "/" + str(ascention_reroller_level),
		upgrade_dice_overrides,
		enemy_exclusive_feathers_overrides,
	];
	
	
	var save = "";
	var i = 0;
	for r in saveResources:
		save += str(r)
		if i != saveResources.size()-1:
			save += "|";
		i+=1;
	print("Export");
	print(save);
	return Marshalls.utf8_to_base64(save);
	pass

func importSave(saveString: String):
	saveString = Marshalls.base64_to_utf8(saveString);

	enemyPool = 4;
	maxDiceRollTime = 4.5;

	saveString = saveString.strip_edges(true,true);
	print("Import");
	print(saveString);
	
	var s = saveString.split("|");
	
	currency = int(s[0]);
	feathers = int(s[1]);
	
	upgrade_save_overrides = s[2];
	
	var a_dps = s[3].split("/");
	ascention_dps_multiplier_value = int(a_dps[0]);
	ascention_dps_multiplier_level = int(a_dps[1]);
	var a_reroll = s[4].split("/");
	ascention_reroller_value = int(a_reroll[0]);
	ascention_reroller_level = int(a_reroll[1]);
	
	upgrade_dice_overrides = s[5];
	
	enemy_exclusive_feathers_overrides = s[6];

	pass

func _init():
	autoImportSave();

func saveGame():
	var save = exportSave();
	var file = File.new()
	file.open(Globals.saveFileLocation, File.WRITE)
	file.store_string(save)
	file.close()
	return true

func autoImportSave():
	var file = File.new()
	if file.file_exists(saveFileLocation) == false:
		file.close()
		return
	file.open(saveFileLocation, File.READ)
	var content = file.get_as_text()
	print(content)
	file.close()
	
	if content != "":
		importSave(content);
