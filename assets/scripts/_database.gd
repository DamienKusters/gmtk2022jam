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
		], .025),
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
		#TODO: Balance from here
		EnemyTier.new([# killed nymph maxed on DPS lvl 4
			EnemyModel.new("Pixie", 2100, 900, "Fairy"),
			EnemyModel.new("Witch", 3000, 1000),
			EnemyModel.new("Fairy", 5000, 1200, "Pixie_Man"),
			EnemyModel.new("Nymph", 7000, 1550, "Earth_Lady",Enums.DiceEnum.D10),
		], .06),
		EnemyTier.new([#killed necro maxed on DPS 7 !!!!!!!!!!!!!!!!!!!!!!!!
			EnemyModel.new("Skeleton", 8000, 1800),
			EnemyModel.new("Wizard", 10500, 2023),
			EnemyModel.new("Wrath", 11500, 2200),
			EnemyModel.new("Necromancer", 13000, 2500, "Necromancer",Enums.DiceEnum.D12),
		], .07),
		EnemyTier.new([#killed power maxed on DPS 12
			EnemyModel.new("Earth Elemental", 19000, 2700, "Earth_Elemental",Enums.DiceEnum.D10),
			EnemyModel.new("Water Elemental", 20000, 2900, "Water_Elemental",Enums.DiceEnum.D10),
			EnemyModel.new("Fire Elemental", 22000, 3000, "Fire_Elemental",Enums.DiceEnum.D12),
			EnemyModel.new("Power Elemental", 23000, 3300, "Volt_Elemental",Enums.DiceEnum.D12),
		], .09),
		EnemyTier.new([
			EnemyModel.new("Angel", 32000, 0, "Angel", null, Enums.LootType.FEATHERS),
			EnemyModel.new("Light", 38000, 4000),
		], .2, Enums.LootType.DARK_FEATHERS)
	]

var dark_enemy_pool = [#TODO: balance feathers: more feathers to grind for the upgreades and not use light
	EnemyTier.new([# TODO: fix 
		EnemyModel.new("Vampire", 30000, 5000, "BatB"),
		EnemyModel.new("Corrosive Jelly", 35000, 5800, "GelatinousCube"),
		EnemyModel.new("Hellhound", 45000, 7600, "Salamander"),
	], .33, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Cobald Wolf", 50000, 8000, "Cobald_Wolf"),
		EnemyModel.new("Wild Boar", 64000, 10000, "WildBoarB"),
		EnemyModel.new("Poisonous Hornet", 70000, 15000, "GiantHornetB"),
	], .25, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([# CHECK more loot from here (expo growth)
		EnemyModel.new("Elite Hobgoblin", 74000, 25000, "Elite_Goblin"),
		EnemyModel.new("Impish Orc", 100000, 48000, "OrcB"),
		EnemyModel.new("Troll", 115000, 50000, "OgreB"),
	], .25, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Corrupted Roots", 125000, 88000, "AnimatedPlantB"),
#		EnemyModel.new("Drone", 315000, 0, "DestroyerV1", Enums.DiceEnum.D20, Enums.LootType.BOLTS),
		EnemyModel.new("Undead Log", 140000, 92000, "TreantB"),
	], .25, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Sprite", 200000, 125000, "FairyB"),
		EnemyModel.new("Naiad", 220000, 150000, "Earth_Lady_Vampire"),
		EnemyModel.new("Dark Fairy", 255000, 200000, "Pixie_Man_Vampire"),
	], .2, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Blood Skeleton", 270000, 370000, "SkeletonB"),
		EnemyModel.new("Archmage", 300000, 450000, "WizardB"),
		EnemyModel.new("Lich", 330000, 500000),
	], .2, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Dark Lord", 350000, 666666, "Demon"),
		EnemyModel.new("Darkness", 370000, 1000000),
	], .1, Enums.LootType.DARK_FEATHERS),
]

func _ready():
	for i in _enemy_pool_level:
		upgradeEnemyTier(i)

func upgradeEnemyTier(index: int):
	enemy_pool[index] = dark_enemy_pool[index]

func _init():
	initEnemyPool()

var help = {
	"game": [
		{
			"name": "Bounty & Feathers",
			"description": "Defeating enemies will grant you bounty to spent on upgrades.\n\nFeathers are a rare drop from enemies, you may use feathers to unlock permanent buffs upon ascending. Feathers are not persisted in between ascensions.\n\nShadow feathers are used to unlock Shadow Upgrades upon ascending. Shadow feathers are persisted in between ascensions.",
		},
		{
			"name": "Enemies",
			"description": "At all times an enemy is on-screen, they will remain there for 8 seconds before being swapped out.\nIf you defeat the enemy within the time limit, you will receive the indicated bounty underneath the enemy's name.",
		},
		{
			"name": "Shields",
			"description": "Certain enemies are immune to a specific kind of dice, this is indicated with a shield next to the enemy.\nEnemies can only be damaged by using dice not indicated on the shield. The shield cannot be destroyed.",
		},
		{
			"name": "Contract progression",
			"description": "When leveling the 'Contract' upgrade, you are tasked to defeat a specific enemy in order to continue leveling the contract.\n\nThe more difficult the enemies, the more bounty and feathers you will receive from them.",
		},
		{
			"name": "Ascending",
			"description": "Ascending will reset your current progress and allows you to spend collected (shadow) feathers for permanent buffs and upgrades.",
		},
		{
			"name": "Saving & Loading",
			"description": "You can manually save the game through the 'Options' menu.\nThe game will be saved in the browser's local storage.\nWhen a save file is found when the game starts, it will load that save automatically.\nBuying new upgrades will also automatically save the game.",
		},
	],
	"upgrades": [
		{
			"name": "Add Dice",
			"description": "Adds another D4 dice.",
			"icon": "res://assets/sprites/upgrades/Add_Dice_Icon.png",
		},
		{
			"name": "Upgrade Dice",
			"description": "Upgrade the lowest ranking dice to the next one.",
			"icon": "res://assets/sprites/upgrades/Upgrade_Dice_Icon.png",
			"contextImage": "res://assets/sprites/help/dice.png",
		},
		{
			"name": "Dungeon Master",
			"description": "Automatically rolls a die at a set interval.\nUpgrading will speed up the interval.",
			"icon": "res://assets/sprites/upgrades/Dungeon_Master_Icon.png",
		},
		{
			"name": "Dice Tray",
			"description": "Each level decreases the maximum dice rolling time by 0.2 seconds.\nDice will gradually roll faster, resulting in a better damage output.",
			"icon": "res://assets/sprites/upgrades/DiceTray.png",
		},
		{
			"name": "Re-roller",
			"description": "Automatically re-rolls any dice equal to or below the level of the upgrade.",
			"icon": "res://assets/sprites/upgrades/Auto_Roll.png",
		},
		{
			"name": "Contract",
			"description": "Adds new enemy encounters.\nNew enemies will be more difficult to defeat but grant more rewards.",
			"icon": "res://assets/sprites/upgrades/Contract.png",
		},
		#todo delete dice
		{
			"name": "Enhance Dice",
			"description": "Shadow upgrade of 'Upgrade Dice'\nEnhances D20 dice to a D100 variant.",
			"icon": "res://assets/sprites/upgrades/Upgrade_Dice_100_Icon.png",
		},
		{
			"name": "Quickroll",
			"description": "Shadow upgrade of 'Dungeon Master'\nOn clicking, you automatically roll the amount of dice same as its level.",
			"icon": "res://assets/sprites/upgrades/Quickroll.png",
		},
		{
			"name": "Dice Tower",
			"description": "Shadow upgrade of 'Dice Tray'\nEach level decreases the minimum and maximum dice rolling time.\nDice will roll incredibly fast.",
			"icon": "res://assets/sprites/upgrades/Dice_Tower.png",
		},
		{
			"name": "Adv.-roller",
			"description": "Shadow upgrade of 'Re-roller'\nAutomatically re-rolls D100 dice starting at face 30 all the way to face 100 in increments of 10.\n(Shorthand for Advantage-roller)",
			"icon": "res://assets/sprites/upgrades/Super_Auto_Roll.png",
		},
		{
			"name": "Hexagram",
			"description": "Shadow upgrade of 'Contract'\nReplaces lower-tier enemies with their shadow realm counterpart.\nShadow enemies are much more difficult to defeat, but will grant much higher bounties and shadow feathers.",
			"icon": "res://assets/sprites/upgrades/Hexagram.png",
		}
	],
	"ascend": [
		{
			"name": "Feather Value",
			"description": "Unspent feathers during an ascension will be converted into 10 bounty each. This will become the starting bounty for the next game.\nThe value of each feather can be multiplied by the 'Feather Value Multiplier' Prime Dice.\nShadow Feathers won't be converted and will be persisted in between ascensions.",
		},
		{
			"name": "Prime Dice",
			"description": "Prime dice are permanent buffs you can unlock by spending feathers.\nYou can either roll the dice for a chance of getting a higher value, or you can upgrade the dice to allow higher rolls.\nThe max value of a prime dice is 20.",
			"icon": "res://assets/sprites/upgrades/Ascend_Icon.png",
		},
		{
			"name": "Shadow Upgrades",
			"description": "Shadow upgrades are extensions of the regular upgrades, they can be unlocked by spending shadow feathers.\nShadow upgrades unlock when the associated upgrade reaches its max level.",
			"icon": "res://assets/sprites/upgrades/Descend_Icon.png",
		},
		{
			"name": "Feather Value Multiplier",
			"description": "Prime Dice.\nMultiplies the value of unspent feathers that will be converted into bounty when ascending.",
		},
		{
			"name": "Damage Multiplier",
			"description": "Prime Dice.\nMultiplies the dice damage output by its value.",
		},
		{
			"name": "Re-roller Starting Level",
			"description": "Prime Dice.\nStarting level of the Re-roller upgrade.",
		},
	],
	"credits": [
		{
			"name": "Dice & Dragons - Extended",
			"description": "This is an idle/clicker game. Original concept made during the GMTK 2022 Game Jam.",
			"contextImage": "res://assets/sprites/logo_extended.png",
		},
	]
}
