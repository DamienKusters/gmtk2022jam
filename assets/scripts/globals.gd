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
	], .02),#lower slightly?
	EnemyTier.new([
		EnemyModel.new("Living Roots", 250, 200, "AnimatedPlant"),
		EnemyModel.new("Treant", 290, 250),
		EnemyModel.new("Gaia", 320, 290),
		EnemyModel.new("Golem", 430, 444, "Nature_Gorilla", Enums.DiceEnum.D6),
	], .04),#lower slightly? nah
	EnemyTier.new([
		EnemyModel.new("Pirate", 680, 500),
		EnemyModel.new("Barbarian", 800, 550, "Bigfoot"),
		EnemyModel.new("Bandit", 900, 600),
		EnemyModel.new("Minotaur", 1300, 666, "Minotaur",Enums.DiceEnum.D8),
	], .05),## All prior stuff is balanced quite good (x12 dmg and got 7 fets in small time)
	EnemyTier.new([# x12 is doable -> thats too high (x6 +) test this out
		EnemyModel.new("Pixie", 2100, 880, "Fairy"),
		EnemyModel.new("Witch", 3000, 900),
		EnemyModel.new("Fairy", 5000, 1000, "Pixie_Man"),
		EnemyModel.new("Nymph", 7000, 1550, "Earth_Lady",Enums.DiceEnum.D10),
	], .06),
	EnemyTier.new([#Too buffed! boss is hard with x12 dmg maxed -> 12 is half of the dice so or x8 should suffice create new hp and currency balance
		EnemyModel.new("Skeleton", 14000, 2000),
		EnemyModel.new("Wrath", 16000, 2100),
		EnemyModel.new("Wizard", 18000, 2300),
		EnemyModel.new("Necromancer", 21000, 2700, "Necromancer",Enums.DiceEnum.D12),
	], .07),
	EnemyTier.new([# 12x must be difficult -> use hp from previous tier!!!!!
		EnemyModel.new("Earth Elemental", 16000, 2100, "Earth_Elemental",Enums.DiceEnum.D10),
		EnemyModel.new("Water Elemental", 18000, 2300, "Water_Elemental",Enums.DiceEnum.D10),
		EnemyModel.new("Fire Elemental", 19000, 2700, "Fire_Elemental",Enums.DiceEnum.D12),
		EnemyModel.new("Power Elemental", 21000, 3000, "Volt_Elemental",Enums.DiceEnum.D12),
	], .08),
	EnemyTier.new([# higher then x14 for light and dark higher then x16 for angel higher then x19 for demon? 
		#redo tier with 1 special enemy? remove demon for 'shadow dark update?'
		EnemyModel.new("Light", 1, 1),
		EnemyModel.new("Darkness", 1, 1),
		EnemyModel.new("Demon Lord", 1, 1, "Demon", null, Enums.LootType.DEMON_FEATHER),
		EnemyModel.new("Angel", 1, 1, "Angel", null, Enums.LootType.FEATHER),
	], 0),
	EnemyTier.new([# x18 or higher to kill, need buffer enemies? or make this one difficult as it is (reuse bosses?)
		EnemyModel.new("Destroyer Drone", 40000, 0, "DestroyerV1", null, Enums.LootType.GEAR),
	], 0),
]

#var old_enemy_pool = [
#	EnemyTier.new([
#		EnemyModel.new("Slime", 4, 5),
#		EnemyModel.new("Bird", 6, 7),
#		EnemyModel.new("Wolf", 9, 10),
#		EnemyModel.new("Goblin", 25, 20, "Regular_Goblin"),
#	], 0),
#	EnemyTier.new([
#		EnemyModel.new("Cobalt Wolf", 26, 50,"Cobald_Wolf"),
#		EnemyModel.new("Hobgoblin", 30, 60,"Elite_Goblin"),
#		EnemyModel.new("Pirate", 35, 70),
#		EnemyModel.new("Bandit", 55, 70),
#	], 0),
#	EnemyTier.new([
#		EnemyModel.new("Witch", 65, 100),
#		EnemyModel.new("Gaia", 95, 111),
#		EnemyModel.new("Minotaur", 120, 150),
#		EnemyModel.new("Golem", 190, 200, "Nature_Gorilla",Enums.DiceEnum.D4),
#	], .001),
#	EnemyTier.new([
#		EnemyModel.new("Pixie", 250, 200, "Earth_Lady"),
#		EnemyModel.new("Fairy", 290, 250, "Pixie_Man"),
#		EnemyModel.new("Wrath", 320,290),
#		EnemyModel.new("Necromancer", 430, 444, "Necromancer",Enums.DiceEnum.D6),
#	], .001),
#	EnemyTier.new([
#		EnemyModel.new("Demon Pixie", 620, 500, "Earth_Lady_Vampire"),
#		EnemyModel.new("Demon Fairy", 650, 550, "Pixie_Man_Vampire"),
#		EnemyModel.new("Lich", 800,600),
#		EnemyModel.new("Demon Lord", 1200, 666, "Demon",Enums.DiceEnum.D8),
#	], .005),
#	EnemyTier.new([
#		EnemyModel.new("Earth Elemental", 2000, 800, "Earth_Elemental",Enums.DiceEnum.D10),
#		EnemyModel.new("Water Elemental", 4000, 1000, "Water_Elemental",Enums.DiceEnum.D12),
#		EnemyModel.new("Fire Elemental", 3000, 900, "Fire_Elemental",Enums.DiceEnum.D12),
#		EnemyModel.new("Power Elemental", 5000,1100, "Volt_Elemental",Enums.DiceEnum.D10),
#	], .05),
#	EnemyTier.new([
#		EnemyModel.new("Light", 8500, 1111, "Light", null, Enums.DiceEnum.D12),
#		EnemyModel.new("Darkness", 8500, 1111, "Darkness", null, Enums.DiceEnum.D10),
#		EnemyModel.new("Angel", 10000, 0, "Angel", null, Enums.LootType.FEATHER),
#	], .1),
#]

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
