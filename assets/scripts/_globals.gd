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

var contractLevel;
var maxDiceRollTime = 5;
var currency = 0
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

func ascendReset():
	upgrade_save_overrides = null;
	upgrade_dice_overrides = null;
	self.currency = 10 * feathers;
	feathers = 0;
	contractLevel = 0;
	maxDiceRollTime = 5;
	
func tryUpgradeDice(price):
	if(currency < price):
		return
	emit_signal("upgradeDice")
	
func upgradeEnemyPool():
	contractLevel += 1
	
func openHelp(txt: Texture, title: String, description: String):
	var obj = {
		"texture": txt,
		"title": title,
		"description": description
	};
	emit_signal("openHelp", obj);

func getRandomEnemyTier():#change to get random enemy instead????
	rng.randomize();
	var idx = rng.randi_range(0, contractLevel)
	return Database.enemy_pool[idx]
	
func addCurrency(value: int):
	self.currency += value;
	emit_signal("currencyUpdated", currency);
	emit_signal("currencyAddedSingular", value);
	Save.exportSave(Enums.SaveFlag.CURRENCY, currency)
	
func removeCurrency(value: int):
	self.currency -= value;
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
	
func upgradeSavesUpdated(save):
	upgrade_save_overrides = save;
	
func upgradeDiceOverridesUpdated(save):
	upgrade_dice_overrides = save;

func _init():
	contractLevel = 0;
	maxDiceRollTime = 5;
	
	currency = Save.importSave(Enums.SaveFlag.CURRENCY, 0);
	feathers = Save.importSave(Enums.SaveFlag.FEATHERS, 0);
	
	ascention_dps_multiplier_value = Save.importSave(Enums.SaveFlag.A_MULTIPLIER_VALUE, 1);
	ascention_dps_multiplier_level = Save.importSave(Enums.SaveFlag.A_MULTIPLIER_LEVEL, 0);
	ascention_reroller_value = Save.importSave(Enums.SaveFlag.A_REROLL_VALUE, 0);
	ascention_reroller_level = Save.importSave(Enums.SaveFlag.A_REROLL_LEVEL, 0);
