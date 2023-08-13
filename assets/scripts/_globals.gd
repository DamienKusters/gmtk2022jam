extends Node

onready var game = "res://scenes/main.tscn";

signal addDice;#TODO: add back functions to keep signals in check
signal upgradeDice;
signal upgradeDiceSuccess;#todo
signal rollRandomDice;#todo
signal damageEnemy;#todo
signal currencyUpdated;
signal feathersUpdated;
signal boltsUpdated;
signal dFeathersUpdated;
signal currencyAddedSingular;
signal openHelp;
signal enemyKilled;#todo

var contractLevel;
var minDiceRollTime = .5
var maxDiceRollTime = 5
var currency = 0
var feathers = 0;
var bolts = 0 setget setBolts;
var dFeathers = 0 setget setDFeathers;
var featherValue = 1;

var ascention_dps_multiplier_value = 1;
var ascention_dps_multiplier_level = 0;
var ascention_reroller_value = 0;
var ascention_reroller_level = 0;

var options_music = 1;
var options_sound = 2;

#TODO: global rng object & seeded object
var rng = RandomNumberGenerator.new()

func setBolts(value):
	bolts = value
	emit_signal("boltsUpdated", value)
	Save.exportSave(Enums.SaveFlag.BOLTS, value)

func setDFeathers(value):
	dFeathers = value
	emit_signal("dFeathersUpdated", value)
	Save.exportSave(Enums.SaveFlag.DARK_FEATHERS_COLLECTED, 1)
	Save.exportSave(Enums.SaveFlag.DARK_FEATHERS, value)
	
func tryUpgradeDice(price, enhanced = false):
	if(currency < price):
		return
	emit_signal("upgradeDice", enhanced)
	
func upgradeEnemyPool():
	contractLevel += 1
	
func openHelp(txt: Texture, title: String, description: String):
	var obj = {
		"texture": txt,
		"title": title,
		"description": description
	};
	emit_signal("openHelp", obj);

func getRandomEnemyTier():
	rng.randomize();
	var idx = rng.randi_range(0, contractLevel)
	return Database.enemy_pool[idx]
	
func addCurrency(value: int):
	currency += value;
	emit_signal("currencyUpdated", currency);
	emit_signal("currencyAddedSingular", value);
	Save.exportSave(Enums.SaveFlag.CURRENCY, currency)
	
func removeCurrency(value: int):
	currency -= value;
	emit_signal("currencyUpdated", currency);
	Save.exportSave(Enums.SaveFlag.CURRENCY, currency)

func addFeathers(value: int):
	feathers += value;
	emit_signal("feathersUpdated", feathers);
	Save.exportSave(Enums.SaveFlag.FEATHERS, feathers)
	
func removeFeathers(value: int):
	feathers -= value;
	emit_signal("feathersUpdated", feathers);
	Save.exportSave(Enums.SaveFlag.FEATHERS, feathers)
	
func getDiceData(enumValue):
	return Database.dice_data[int(enumValue)];

func _init():
	Database.initEnemyPool()
	contractLevel = 0;
	minDiceRollTime = .5
	maxDiceRollTime = 5;
	
	currency = Save.importSave(Enums.SaveFlag.CURRENCY, 0);
	feathers = Save.importSave(Enums.SaveFlag.FEATHERS, 0);
	bolts = Save.importSave(Enums.SaveFlag.BOLTS, 0);
	dFeathers = Save.importSave(Enums.SaveFlag.DARK_FEATHERS, 0);
	
	ascention_dps_multiplier_value = Save.importSave(Enums.SaveFlag.A_MULTIPLIER_VALUE, 1);
	ascention_dps_multiplier_level = Save.importSave(Enums.SaveFlag.A_MULTIPLIER_LEVEL, 0);
	ascention_reroller_value = Save.importSave(Enums.SaveFlag.A_REROLL_VALUE, 0);
	ascention_reroller_level = Save.importSave(Enums.SaveFlag.A_REROLL_LEVEL, 0);
	featherValue = Save.importSave(Enums.SaveFlag.A_FEATHER_VALUE, 1);
