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
	EnemyTier.new([#TODO: Test balancing from this part
		EnemyModel.new("Earth Elemental", 19000, 2700, "Earth_Elemental",Enums.DiceEnum.D10),
		EnemyModel.new("Water Elemental", 20000, 2900, "Water_Elemental",Enums.DiceEnum.D10),
		EnemyModel.new("Fire Elemental", 22000, 3000, "Fire_Elemental",Enums.DiceEnum.D12),
		EnemyModel.new("Power Elemental", 23000, 3300, "Volt_Elemental",Enums.DiceEnum.D12),
	], .08),
	EnemyTier.new([
		EnemyModel.new("Light", 36000, 4000),
		EnemyModel.new("Light", 36000, 4000),
		EnemyModel.new("Angel", 32000, 0, "Angel", null, Enums.LootType.FEATHERS),
		EnemyModel.new("Light", 36000, 4000),
#		EnemyModel.new("Darkness", 36000, 4200),
	], 0),
	EnemyTier.new([
		EnemyModel.new("Demon Lord", 41000, 1, "Demon", null, Enums.LootType.DEMON_FEATHERS),
	], 0),
	#Move drone to the proposed 'secondary dark enemy pool'
#	EnemyTier.new([
#		#TODO: new upgrades to make it possible to destroy this one
#		EnemyModel.new("Destroyer Drone", 400000, 0, "DestroyerV1", null, Enums.LootType.BOLTS),
#	], 0),
]

var dark_enemy_pool = [
	EnemyTier.new([
		EnemyModel.new("Dark Slug", 4, 5, "SlugB"),
		EnemyModel.new("Dark Bat", 9, 10, "BatB"),
		EnemyModel.new("Dark Hornet", 26, 50, "GiantHornetB"),
	], 0),
	EnemyTier.new([
		EnemyModel.new("Dark Rat", 30, 60, "GiantRatB"),
		EnemyModel.new("Cobald Wolf", 35, 70, "Cobald_Wolf"),
		EnemyModel.new("Dark Boar", 55, 70, "WildBoarB"),
	], 0),
	EnemyTier.new([
		EnemyModel.new("Dark Goblin", 65, 100, "GoblinB"),
		EnemyModel.new("Dark Hobgoblin", 95, 111, "Elite_Goblin"),
		EnemyModel.new("Dark Ogre", 120, 150, "OgreB"),
	], 0),
	EnemyTier.new([
		EnemyModel.new("Dark Orc", 190, 200, "OrcB", Enums.DiceEnum.D4),
		EnemyModel.new("Dark Living Roots", 250, 200, "AnimatedPlantB"),
		EnemyModel.new("Dark Treant", 290, 250, "TreantB"),
	], 0),
	EnemyTier.new([
		EnemyModel.new("Dark Pixie", 2100, 900, "FairyB"),
		EnemyModel.new("Dark Fairy", 5000, 1200, "Pixie_Man_Vampire"),
		EnemyModel.new("Dark Nymph", 7000, 1550, "Earth_Lady_Vampire",Enums.DiceEnum.D10),
	], 0),
	EnemyTier.new([
		EnemyModel.new("Dark Skeleton", 8000, 1800, "SkeletonB"),
		EnemyModel.new("Dark Wizard", 10500, 2023, "WizardB"),
		EnemyModel.new("Darkness", 36000, 4200),
	], 0),
	#todo: salamander & lich
	# 4x 6 = 24 enemies?
	# add drone at mid-way point
]

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
	upgrades = loadUpgrades()
