extends Node

const dice_data = {
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
	},
	6:{
		"value": 100,
		"texture": "res://assets/sprites/dice/d100.png",
		"color": Color("545454")
	}
}

onready var _enemy_pool_level = Save.importSave(Enums.SaveFlag.U_HEXAGRAM, 0)
var enemy_pool
func initEnemyPool():
	enemy_pool = [
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
		], .03),#slightly lower to .2??? got 7 from them in a fine timespan
		EnemyTier.new([
			EnemyModel.new("Living Roots", 250, 200, "AnimatedPlant"),
			EnemyModel.new("Living Log", 290, 250, "Treant"),
			EnemyModel.new("Treant", 320, 290, "Gaia"),
			EnemyModel.new("Golem", 430, 444, "Nature_Gorilla", Enums.DiceEnum.D6),
		], .04),
		EnemyTier.new([
			EnemyModel.new("Pirate", 680, 500),
			EnemyModel.new("Barbarian", 800, 550, "Bigfoot"),
			EnemyModel.new("Bandit", 900, 600),
			EnemyModel.new("Minotaur", 1300, 700, "Minotaur",Enums.DiceEnum.D8),
		], .05),
		EnemyTier.new([# killed nymph maxed on DPS lvl 4
			EnemyModel.new("Pixie", 2100, 900, "Fairy"),
			EnemyModel.new("Witch", 3000, 1000),
			EnemyModel.new("Fairy", 5000, 1200, "Pixie_Man"),
			EnemyModel.new("Nymph", 7000, 1550, "Earth_Lady",Enums.DiceEnum.D10),
		], .06),
		EnemyTier.new([#killed necro maxed on DPS 9
			EnemyModel.new("Skeleton", 8000, 1800),
			EnemyModel.new("Wizard", 10500, 2023),
			EnemyModel.new("Wrath", 11500, 2200),
			EnemyModel.new("Necromancer", 13000, 2500, "Necromancer",Enums.DiceEnum.D12),
		], .06),
		EnemyTier.new([#killed power maxed on DPS 14
			EnemyModel.new("Earth Elemental", 19000, 2700, "Earth_Elemental",Enums.DiceEnum.D10),
			EnemyModel.new("Water Elemental", 20000, 2900, "Water_Elemental",Enums.DiceEnum.D10),
			EnemyModel.new("Fire Elemental", 22000, 3000, "Fire_Elemental",Enums.DiceEnum.D12),
			EnemyModel.new("Power Elemental", 23000, 3300, "Volt_Elemental",Enums.DiceEnum.D12),
		], .08),
		EnemyTier.new([# ANGEL KILLED MAXED AT DPS 17 (15 & 16 UNKNOWN) lower angel to 15 minimum
			EnemyModel.new("Angel", 32000, 0, "Angel", null, Enums.LootType.FEATHERS),
			EnemyModel.new("Light", 41000, 4000),# light killed at x17 18/19 minimum
		], .2, Enums.LootType.DARK_FEATHERS)
	]

var dark_enemy_pool = [
	EnemyTier.new([#can be defeated without special upgrades (for farming dfeathers)
		EnemyModel.new("Vampire", 30000, 5000, "BatB"),
		EnemyModel.new("Void Slime", 35000, 5800, "SlimeB"),
		EnemyModel.new("Hellhound", 45000, 7600, "Salamander"),
	], .1, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([#needs first row of enhanced dice 
		EnemyModel.new("Cobald Wolf", 50000, 8000, "Cobald_Wolf"),
		EnemyModel.new("Wild Boar", 64000, 10000, "WildBoarB"),
		EnemyModel.new("Poisonous Hornet", 70000, 15000, "GiantHornetB"),
	], .15, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([# CHECK more loot from here (expo growth)
		EnemyModel.new("Elite Hobgoblin", 74000, 25000, "Elite_Goblin"),
		EnemyModel.new("Impish Orc", 100000, 48000, "OrcB"),
		EnemyModel.new("Troll", 115000, 50000, "OgreB"),
	], .17, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([#second row and more of enhanced, little lower because of drone <3
		EnemyModel.new("Corrupted Roots", 125000, 88000, "AnimatedPlantB"),
		#drone must be lower to paralelize gameplay -> move lower tier? ()
		EnemyModel.new("Drone", 400000, 0, "DestroyerV1", Enums.DiceEnum.D20, Enums.LootType.BOLTS),
		EnemyModel.new("Undead Log", 140000, 92000, "TreantB"),
	], .2, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Lich", 200000, 111111),
	], .33, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Sprite", 200000, 125000, "FairyB"),
		EnemyModel.new("Naiad", 220000, 150000, "Earth_Lady_Vampire"),
		EnemyModel.new("Dark Fairy", 255000, 200000, "Pixie_Man_Vampire"),
	], .2, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Blood Skeleton", 270000, 400000, "SkeletonB"),
		EnemyModel.new("Archmage", 300000, 550000, "WizardB"),
		EnemyModel.new("Dark Lord", 330000, 666666, "Demon"),
		EnemyModel.new("Darkness", 350000, 1000000),
	], .1, Enums.LootType.DARK_FEATHERS),
]

func _ready():
	for i in _enemy_pool_level:
		upgradeEnemyTier(i)

func upgradeEnemyTier(index: int):
	enemy_pool[index] = dark_enemy_pool[index]

#Redo new upgrade system, make use of resource but simplify it
var upgrades
func loadUpgrades():
	return [
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


func _init():
	initEnemyPool()
	upgrades = loadUpgrades()
