extends Node

onready var game = "res://scenes/main.tscn";

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

const saveFileLocation = "user://dnde.save"
var contractLevel;
var maxDiceRollTime = 5;
var currency = 99999990;
var feathers = 0;

var upgrade_save_overrides;
var upgrade_dice_overrides;

var ascention_dps_multiplier_value = 99;
var ascention_dps_multiplier_level = 0;
var ascention_reroller_value = 0;
var ascention_reroller_level = 0;

var options_music = 1;
var options_sound = 2;

#TODO: global rng object & seeded object
var rng = RandomNumberGenerator.new();

const diceData = {
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
	contractLevel = 0;
	maxDiceRollTime = 5;

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
	contractLevel += 1;
	
func killEnemy(enemy):
	emit_signal("enemyKilled", enemy);
	
func openHelp(txt: Texture, title: String, description: String):
	var obj = {
		"texture": txt,
		"title": title,
		"description": description
	};
	emit_signal("openHelp", obj);

func getRandomEnemyTier():
	rng.randomize();
	var idx = rng.randi_range(0, contractLevel);
	return enemy_pool[idx]
	
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

var upgrades

var enemy_pool = [
	EnemyTier.new([
		EnemyModel.new("Slug", 2, 2),
		EnemyModel.new("Bird", 4, 5),
		EnemyModel.new("Bat", 7, 8),
		EnemyModel.new("Slime", 10, 10),
	], 0),
	EnemyTier.new([
		EnemyModel.new("Hornet", 12, 13,"GiantHornet"),
		EnemyModel.new("Rat", 16, 15,"GiantRat"),
		EnemyModel.new("Wolf", 20, 19),
		EnemyModel.new("Boar", 25, 25,"WildBoar"),
	], 0),
	EnemyTier.new([
		EnemyModel.new("Goblin", 35, 30),
		EnemyModel.new("Hobgoblin", 42, 43,"Regular_Goblin"),
		EnemyModel.new("Ogre", 49, 49),
		EnemyModel.new("Orc", 57, 60, "Orc",Enums.DiceEnum.D4),
	], .001),
	EnemyTier.new([
		EnemyModel.new("Living Roots", 95, 111, "AnimatedPlant"),
		EnemyModel.new("Treant", 95, 111),
		EnemyModel.new("Gaia", 95,111),
		EnemyModel.new("Golem", 190, 200, "Nature_Gorilla",Enums.DiceEnum.D6),
	], .001),
	EnemyTier.new([
		EnemyModel.new("Pirate", 95, 111),
		EnemyModel.new("Barbarian", 95, 111, "Bigfoot"),
		EnemyModel.new("Outlaw", 95,111, "Bandit"),
		EnemyModel.new("Minotaur", 190, 200, "Minotaur",Enums.DiceEnum.D6),
	], .005),
	EnemyTier.new([
		EnemyModel.new("Pixie", 95, 111, "Fairy"),
		EnemyModel.new("Witch", 95, 111),
		EnemyModel.new("Fairy", 95,111, "Pixie_Man"),
		EnemyModel.new("Nymph", 190, 200, "Earth_Lady",Enums.DiceEnum.D8),
	], .01),
	EnemyTier.new([
		EnemyModel.new("Skeleton", 95, 111),
		EnemyModel.new("Wrath", 95, 111),
		EnemyModel.new("Wizard", 95,111),
		EnemyModel.new("Necromancer", 190, 200, "Necromancer",Enums.DiceEnum.D10),
	], .02),
	EnemyTier.new([
		EnemyModel.new("Earth Elemental", 95, 111, "Earth_Elemental",Enums.DiceEnum.D10),
		EnemyModel.new("Water Elemental", 190, 200, "Water_Elemental",Enums.DiceEnum.D10),
		EnemyModel.new("Fire Elemental", 95, 111, "Fire_Elemental",Enums.DiceEnum.D12),
		EnemyModel.new("Power Elemental", 95,111, "Volt_Elemental",Enums.DiceEnum.D12),
	], .05),
	EnemyTier.new([
		EnemyModel.new("Light", 10000, 200),
		EnemyModel.new("Darkness", 10000, 111),
		EnemyModel.new("Demon Lord", 10000, 200, "Demon", null, Enums.LootType.DEMON_FEATHER),
		EnemyModel.new("Angel", 10000, 200, "Angel", null, Enums.LootType.FEATHER),
	], .1),
	EnemyTier.new([
		EnemyModel.new("Destroyer Drone", 10000, 111, "DestroyerV1", null, Enums.LootType.GEAR),
	], 0),
]

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
		"shield":Enums.DiceEnum.D4,
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
		"sprite": "res://assets/sprites/enemies/Wrath.png",
		"feather":0,
		"shield":null,
	},
	{
		"name":"Necromancer",
		"health":430,
		"currency":444,
		"sprite": "res://assets/sprites/enemies/Necromancer.png",
		"feather":1,
		"shield":Enums.DiceEnum.D6,
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
		"shield":Enums.DiceEnum.D8,
	},
	#Tier 6: Elementals (TODO: health x8)
	{
		"name":"Earth Elemental",
		"health":2000,
		"currency":800,
		"sprite": "res://assets/sprites/enemies/Earth_Elemental.png",
		"feather":0,
		"shield":Enums.DiceEnum.D10,
	},
	{
		"name":"Fire Elemental",
		"health":3000,
		"currency":900,
		"sprite": "res://assets/sprites/enemies/Fire_Elemental.png",
		"feather":0,
		"shield":Enums.DiceEnum.D12,
	},
	{
		"name":"Power Elemental",
		"health":5000,
		"currency":1100,
		"sprite": "res://assets/sprites/enemies/Volt_Elemental.png",
		"feather":0,
		"shield":Enums.DiceEnum.D10,
	},
	{
		"name":"Water Elemental",
		"health":4000,
		"currency":1000,
		"sprite": "res://assets/sprites/enemies/Water_Elemental.png",
		"feather":0,
		"shield":Enums.DiceEnum.D12,
	},
	# Tier 7: Legendary
	{
		"name":"Darkness",
		"health":8500,
		"currency":1111,
		"sprite": "res://assets/sprites/enemies/Darkness.png",
		"feather":1,
		"shield":Enums.DiceEnum.D10,
	},
	{
		"name":"Light",
		"health":8500,
		"currency":1111,
		"sprite": "res://assets/sprites/enemies/Light.png",
		"feather":1,
		"shield":Enums.DiceEnum.D12,
	},
	{#Special
		"name":"Angel",
		"health":10000,
		"currency":0,
		"sprite": "res://assets/sprites/enemies/Angel.png",
		"feather":-1,
		"shield":null,
	},
];

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
	];
	
	var save = "";
	var i = 0;
	for r in saveResources:
		save += str(r)
		if i != saveResources.size()-1:
			save += "|";
		i+=1;
	print("Game Exported");
	return Marshalls.utf8_to_base64(save);

func importSave(saveString: String):
	saveString = Marshalls.base64_to_utf8(saveString);

	contractLevel = 0;
	maxDiceRollTime = 5;

	saveString = saveString.strip_edges(true,true);
	print("Game Imported");
	
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
	
	pass

func _init():
	contractLevel = 0;
	autoImportSave();

func _ready():
	upgrades = [
		UpgradeModel.new(
			"Add Dice",
			"Adds another D4 dice",
			"res://assets/sprites/upgrades/Add_Dice_Icon.png",
			AddDiceUpgrade.new()
		),
		UpgradeModel.new(
			"Upgrade Dice",
			"Upgrade the lowest ranking dice to the next one (D4, D6, D8 ,D10, D12, D20)",
			"res://assets/sprites/upgrades/Upgrade_Dice_Icon.png",
			Upgrade.new()
		),
		UpgradeModel.new(
			"Dungeon Master",
			"Automatically rolls a dice",
			"res://assets/sprites/upgrades/Dungeon_Master_Icon.png",
			Upgrade.new()
		),
		null,
		UpgradeModel.new(
			"Re-roller",
			"Automatically re-rolls any dice equal to or below the level of the upgrade",
			"res://assets/sprites/upgrades/Auto_Roll.png",
			Upgrade.new()
		),
		null,
		UpgradeModel.new(
			"Contract",
			"Adds new enemy encounters",
			"res://assets/sprites/upgrades/Contract.png",
			ContractUpgrade.new()
		),
		UpgradeModel.new(
			"Dice Tower",
			"Decreases the maximum dice rolling time by each level",
			"res://assets/sprites/upgrades/Dice_Tower.png",
			Upgrade.new()
		),
		UpgradeModel.new(
			"Ascend",
			"Reset your progress and spend Angel Feathers for permanent upgrades",
			"res://assets/sprites/upgrades/Ascend_Icon.png",
			Upgrade.new()
		),
	]

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
	file.close()
	
	if content != "":
		importSave(content);
