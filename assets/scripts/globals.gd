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
var currency = 0;
var feathers = 0;

var upgrade_save_overrides;
var upgrade_dice_overrides;

var ascention_dps_multiplier_value = 1;
var ascention_dps_multiplier_level = 0;
var ascention_reroller_value = 0;
var ascention_reroller_level = 0;

var options_music = 0#1;
var options_sound = 0#2;

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
		EnemyModel.new("Slug", 4, 5),
		EnemyModel.new("Bird", 6, 7),
		EnemyModel.new("Bat", 9, 10),
		EnemyModel.new("Slime", 25, 20),
	], 0),
	EnemyTier.new([
		EnemyModel.new("Hornet", 26, 50, "GiantHornet"),
		EnemyModel.new("Rat", 30, 60, "GiantRat"),
		EnemyModel.new("Wolf", 35, 70),
		EnemyModel.new("Boar", 55, 70, "WildBoar"),
	], .01),
	EnemyTier.new([
		EnemyModel.new("Goblin", 65, 100),
		EnemyModel.new("Hobgoblin", 95, 111, "Regular_Goblin"),
		EnemyModel.new("Ogre", 120, 150),
		EnemyModel.new("Orc", 190, 200, "Orc", Enums.DiceEnum.D4),
	], .03),
	EnemyTier.new([
		EnemyModel.new("Living Roots", 250, 200, "AnimatedPlant"),
		EnemyModel.new("Treant", 290, 250),
		EnemyModel.new("Gaia", 320, 290),
		EnemyModel.new("Golem", 430, 444, "Nature_Gorilla", Enums.DiceEnum.D6),
	], .04),
	EnemyTier.new([
		EnemyModel.new("Pirate", 680, 500),
		EnemyModel.new("Barbarian", 800, 550, "Bigfoot"),
		EnemyModel.new("Bandit", 900, 600),
		EnemyModel.new("Minotaur", 1300, 700, "Minotaur",Enums.DiceEnum.D8),
	], .05),
	EnemyTier.new([
		EnemyModel.new("Pixie", 2100, 900, "Fairy"),
		EnemyModel.new("Witch", 3000, 1000),
		EnemyModel.new("Fairy", 5000, 1200, "Pixie_Man"),
		EnemyModel.new("Nymph", 7000, 1550, "Earth_Lady",Enums.DiceEnum.D10),
	], .06),
	EnemyTier.new([
		EnemyModel.new("Skeleton", 8000, 1800),
		EnemyModel.new("Wizard", 10500, 2023),
		EnemyModel.new("Wrath", 11500, 2200),
		EnemyModel.new("Necromancer", 13000, 2500, "Necromancer",Enums.DiceEnum.D12),
	], .06),
	EnemyTier.new([
		EnemyModel.new("Earth Elemental", 19000, 2700, "Earth_Elemental",Enums.DiceEnum.D10),
		EnemyModel.new("Water Elemental", 20000, 2900, "Water_Elemental",Enums.DiceEnum.D10),
		EnemyModel.new("Fire Elemental", 22000, 3000, "Fire_Elemental",Enums.DiceEnum.D12),
		EnemyModel.new("Power Elemental", 23000, 3300, "Volt_Elemental",Enums.DiceEnum.D12),
	], .08),
	EnemyTier.new([
		EnemyModel.new("Light", 29500, 4000),
		EnemyModel.new("Angel", 32000, 0, "Angel", null, Enums.LootType.FEATHER),
		#TODO: demon
		EnemyModel.new("Demon Lord", 38000, 666, "Demon", null, Enums.LootType.DEMON_FEATHER),
		EnemyModel.new("Darkness", 40000, 4000),
	], 0),
	EnemyTier.new([
		#TODO: new upgrades to make it possible to destroy this one
		EnemyModel.new("Destroyer Drone", 400000, 0, "DestroyerV1", null, Enums.LootType.GEAR),
	], 0),
]

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
	print(save)
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
