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
		EnemyTier.new([# killed nymph maxed on DPS lvl 4
			EnemyModel.new("Pixie", 2100, 900, "Fairy"),
			EnemyModel.new("Witch", 3000, 1000),
			EnemyModel.new("Fairy", 5000, 1200, "Pixie_Man"),
			EnemyModel.new("Nymph", 7000, 1550, "Earth_Lady",Enums.DiceEnum.D10),
		], .06),
		EnemyTier.new([#killed necro maxed on DPS 7
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
		], .2, Enums.LootType.FEATHERS)
	]

var dark_enemy_pool = [
	EnemyTier.new([
		EnemyModel.new("Poisonous Slug", 30000, 5000, "SlugB"),
		EnemyModel.new("Vampire", 35000, 5800, "BatB"),
		EnemyModel.new("Corrosive Jelly", 45000, 7600, "GelatinousCube"),
	], .33, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Cobald Wolf", 50000, 8000, "Cobald_Wolf"),
		EnemyModel.new("Venomous Wasp", 70000, 15000, "GiantHornetB"),
		EnemyModel.new("Hellhound", 64000, 10000, "Salamander"),
	], .25, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Gremlin", 74000, 25000, "GoblinB"),
		EnemyModel.new("Feral Rat", 100000, 48000, "GiantRatB"),
		EnemyModel.new("Elite Hobgoblin", 115000, 50000, "Elite_Goblin"),
	], .25, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Berserker", 125000, 88000, "BigfootB"),
		EnemyModel.new("Impish Orc", 130000, 92000, "OrcB"),
		EnemyModel.new("Troll", 140000, 100000, "OgreB"),
	], .2, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Corrupted Roots", 155000, 110000, "AnimatedPlantB"),
		EnemyModel.new("Undead Log", 170000, 115000, "TreantB"),
	], .2, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Sprite", 180000, 125000, "FairyB"),
		EnemyModel.new("Naiad", 200000, 150000, "Earth_Lady_Vampire"),
		EnemyModel.new("Dark Fairy", 255000, 200000, "Pixie_Man_Vampire"),
	], .2, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Blood Skeleton", 270000, 370000, "SkeletonB"),
		EnemyModel.new("Archmage", 300000, 450000, "WizardB"),
		EnemyModel.new("Lich", 330000, 500000),
	], .2, Enums.LootType.DARK_FEATHERS),
	EnemyTier.new([
		EnemyModel.new("Dark Lord", 350000, 0, "Demon", null, Enums.LootType.DARK_FEATHERS),
		EnemyModel.new("Darkness", 370000, 1000000),
		EnemyModel.new("D.R.O.N.E", 4300000, 0, "DestroyerV1", null, Enums.LootType.BOLTS),
	], 0, Enums.LootType.DARK_FEATHERS),
]

func _ready():
	for i in _enemy_pool_level:
		upgradeEnemyTier(i)

func upgradeEnemyTier(index: int):
	enemy_pool[index] = dark_enemy_pool[index]

func _init():
	initEnemyPool()

var upgrades = {
	"add_dice": {
		"name": "Add Dice",
		"description": "Adds another D4 dice.\n\nCosts 50 shadow feathers to upgrade to 'Harvest Dice'",
		"icon": load("res://assets/sprites/upgrades/Add_Dice_Icon.png"),
		"contextImage": load("res://assets/sprites/help/add_dice.png"),
		"helpIndex": 0,
	},
	"upgrade_dice": {
		"name": "Upgrade Dice",
		"description": "Upgrade the lowest ranking dice to the next one.\n\nCosts 3 shadow feathers to upgrade to 'Enhance Dice'",
		"icon": load("res://assets/sprites/upgrades/Upgrade_Dice_Icon.png"),
		"contextImage": load("res://assets/sprites/help/dice.png"),
		"helpIndex": 1,
	},
	"dungeon_master": {
		"name": "Dungeon Master",
		"description": "Automatically rolls a die at a set interval.\nUpgrading will speed up the interval.\n\nCosts 20 shadow feathers to upgrade to 'Quickroll'",
		"icon": load("res://assets/sprites/upgrades/Dungeon_Master_Icon.png"),
		"helpIndex": 2,
	},
	"dice_tray": {
		"name": "Dice Tray",
		"description": "Each level decreases the maximum dice rolling time by 0.2 seconds.\nDice will gradually roll faster, resulting in a better damage output.\n\nCosts 12 shadow feathers to upgrade to 'Dice Tower'",
		"icon": load("res://assets/sprites/upgrades/DiceTray.png"),
		"helpIndex": 3,
	},
	"re_roller": {
		"name": "Re-roller",
		"description": "Automatically re-rolls any dice that rolled a face value equal to or below the level of the upgrade.\n\nCosts 35 shadow feathers to upgrade to 'Adv.-roller'",
		"icon": load("res://assets/sprites/upgrades/Auto_Roll.png"),
		"helpIndex": 4,
	},
	"contract": {
		"name": "Contract",
		"description": "Adds new enemy encounters.\nNew enemies will be more difficult to defeat but grant more rewards.\n\nCosts 1 shadow feather to upgrade to 'Hexagram'",
		"icon": load("res://assets/sprites/upgrades/Contract.png"),
		"helpIndex": 5,
	},
	"harvest_dice": {
		"name": "Harvest Dice",
		"description": "Shadow upgrade of 'Add Dice'\nConverts dice into feathers or shadow feathers\n\n...\nAlso 'unlocks' something else...",# or bolts.
		"icon": load("res://assets/sprites/upgrades/Delete_Dice_Icon.png"),
		"helpIndex": 6,
	},
	"enhance_dice": {
		"name": "Enhance Dice",
		"description": "Shadow upgrade of 'Upgrade Dice'\nEnhances D20 dice to a D100 variant.",
		"icon": load("res://assets/sprites/upgrades/Upgrade_Dice_100_Icon.png"),
		"contextImage": load("res://assets/sprites/help/enhance_dice.png"),
		"helpIndex": 7,
	},
	"quickroll": {
		"name": "Quickroll",
		"description": "Shadow upgrade of 'Dungeon Master'\nOn clicking, you automatically roll the amount of dice same as its level.",
		"icon": load("res://assets/sprites/upgrades/Quickroll.png"),
		"helpIndex": 8,
	},
	"dice_tower": {
		"name": "Dice Tower",
		"description": "Shadow upgrade of 'Dice Tray'\nEach level decreases the minimum and maximum dice rolling time.\nDice will roll incredibly fast.",
		"icon": load("res://assets/sprites/upgrades/Dice_Tower.png"),
		"helpIndex": 9,
	},
	"adv_roller": {
		"name": "Adv.-roller",
		"description": "Shadow upgrade of 'Re-roller'\nAutomatically re-rolls D100 dice starting at face 30 all the way to face 100 in increments of 10.\n(Shorthand for Advantage-roller)",
		"icon": load("res://assets/sprites/upgrades/Super_Auto_Roll.png"),
		"helpIndex": 10,
	},
	"hexagram": {
		"name": "Hexagram",
		"description": "Shadow upgrade of 'Contract'\nReplaces lower-tier enemies with their shadow realm counterpart.\nShadow enemies are much more difficult to defeat, but will grant much higher bounties and shadow feathers.",
		"icon": load("res://assets/sprites/upgrades/Hexagram.png"),
		"helpIndex": 11,
	}
}

var help = {
	"game": [
		{
			"name": "Upgrades",
			"description": "The upgrades, at the right of the screen, can be levelled with bounty received from defeating enemies. \n\nMore information about what each upgrade does can be read by clicking the orange exclamation mark '?'",
		},
		{
			"name": "Bounty & Feathers",
			"description": "Defeating enemies will grant you bounty to spent on upgrades.\n\nFeathers are a rare drop from enemies, you may use feathers to unlock permanent buffs upon ascending. Feathers are not persisted in between ascensions.\n\nShadow feathers are used to unlock Shadow Upgrades upon ascending. Shadow feathers are persisted in between ascensions.",
		},
		{
			"name": "Enemies",
			"description": "At all times an enemy is on-screen, they will remain there for 8 seconds before being swapped out.\n\nIf you defeat the enemy within the time limit, you will receive the indicated bounty underneath the enemy's name.",
		},
		{
			"name": "Shields",
			"description": "Certain enemies are immune to a specific kind of dice, this is indicated with a shield next to the enemy.\n\nEnemies can only be damaged by using dice not indicated on the shield.\nThe shield cannot be destroyed.",
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
			"description": "You can manually save the game through the 'Options' menu.\n\nThe game will be saved in the browser's local storage.\n\nWhen a save file is found when the game starts, it will load that save automatically.\n\nBuying new upgrades will also automatically save the game.",
		},
		{
			"name": "Buy in bulk",
			"description": "Upgrades can be bought in bulk by holding down 'SHIFT' and clicking on the upgrade you want to buy in bulk.",
		}
	],
	"upgrades": [
		self.upgrades['add_dice'],
		self.upgrades['upgrade_dice'],
		self.upgrades['dungeon_master'],
		self.upgrades['dice_tray'],
		self.upgrades['re_roller'],
		self.upgrades['contract'],
		self.upgrades['harvest_dice'],
		self.upgrades['enhance_dice'],
		self.upgrades['quickroll'],
		self.upgrades['dice_tower'],
		self.upgrades['adv_roller'],
		self.upgrades['hexagram'],
	],
	"ascend": [
		{
			"name": "Prime Dice",
			"description": "Prime dice are permanent buffs you can unlock by spending feathers.\n\nYou can either roll the dice for a chance of getting a higher value, or you can upgrade the dice to allow higher rolls.\n\nThe max value of a prime dice is 20.",
			"icon": load("res://assets/sprites/upgrades/Ascend_Icon.png"),
		},
		{
			"name": "Shadow Upgrades",
			"description": "Shadow upgrades are extensions of the regular upgrades, they can be unlocked by spending shadow feathers.\n\nShadow upgrades unlock when the associated upgrade reaches its max level.\n\nIf all shadow upgrades are purchased, you can convert 10 shadow feathers into an additional x1 on top of the damage multiplier.",
			"icon": load("res://assets/sprites/upgrades/Descend_Icon.png"),
		},
		{
			"name": "Starting Bounty",
			"description": "Unspent feathers during an ascension will be converted into 10 bounty each. This will become the starting bounty for the next game.\n\nThe value of each feather can be multiplied by the 'Feather Value Multiplier' Prime Dice.\n\nShadow Feathers won't be converted and will be persisted in between ascensions.",
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
			"name": "About",
			"description": "Dice & Dragons - Extended is an updated version of the GMTK Game Jam 2022 submission: Dice & Dragons.\n(damienkusters.itch.io/dice-dragons)",
			"contextImage": load("res://assets/sprites/logo_extended.png"),
		},
		{
			"name": "Development",
			"description": "Developed by Damien Kusters (damienkusters.itch.io)\n\nCreative assistance by Marco van Stiphout (itch.io/profile/marcovanstiphout)",
		},
		{
			"name": "Art",
			"description": "'JS Monsters' by JosephSeraph\n(opengameart.org/users/josephseraph)\n\n'RPG Monster pack' by itchabop (itchabop.itch.io)\n\n'Board Game Icons' by kenney.nl",
		},
		{
			"name": "Background Art",
			"description": "'Parallax Forest' and 'Mountain Dusk Parallax' by Ansimuz (ansimuz.itch.io)"
		},
		{
			"name": "Music & Sound",
			"description": "'The Adventurer's Collection Tabletop Soundtrack' by Slaleky (slaleky.itch.io)\n\n'Hiding Your Reality' & 'Harmful or Fatal'\nby Kevin MacLeod\n\n'Collect_Point_00' by LittleRobotSoundFactory (freesound.org/people/LittleRobotSoundFactory)\n\n'Coins - 01' by DWOBoyle (freesound.org/people/DWOBoyle)",
		},
		{
			"name": "Font",
			"description": "'Almendra' by Fontsource (fontsource.org/fonts/almendra)",
		},
	],
	"destroyer": [
		{
			"name": "The Destroyer",
			"description": "This is it...\nThe Destroyer has awakend to reign over the lands.\nThis is the final challenge of: Dice & Dragons - Extended",
			"contextImage": load("res://assets/sprites/enemies/DestroyerV2_noshadow.png"),
		},
		{
			"name": "Bolts",
			"description": "Bolts are the currency to buy upgrades related to The Destroyer fight.\nBolts are dropped by the rare D.R.O.N.E enemy.\nUpgrade Boutiful Harvest to collect bolts from harvesting dice.",
			"contextImage": load("res://assets/sprites/icons/bolt.png"),
		},
		{
			"name": "Add Mechanical Dice",
			"description": "",
		},
		{
			"name": "Upgrade Mech.Dice",
			"description": "",
		},
		{
			"name": "Boutiful Harvest",
			"description": "Add a +5% chance of receiving a bolt.",
			"icon": load("res://assets/sprites/upgrades/Boutiful_Harvest.png"),
		},
	]
}
