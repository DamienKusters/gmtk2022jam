extends Node

onready var game = "res://scenes/main.tscn";

signal addDice;#TODO: add back functions to keep signals in check
signal upgradeDice
signal upgradeDiceSuccess;#todo
signal rollRandomDice;#todo
signal damageEnemy;#todo
signal currencyUpdated
signal feathersUpdated
signal boltsUpdated
signal dFeathersUpdated
signal currencyAddedSingular
signal openHelp
signal enemyKilled;#todo
signal deleteDice;#todo
signal triggerDestroyerShowButton

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

var du_bounty_multiplier = 1
var du_feather_multiplier = 1
var du_s_feather_multiplier = 1

var du_add_dice_max = false
var du_dm_max = false
var du_tray_max = false

var options_music = 1;
var options_sound = 2;

# From destroyer
const EPOCH_THOUSAND_YEARS: float = 31556995200.00
const SIMULATED_UPGRADES: int = 13

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
	
func openHelp(index, page):
	emit_signal("openHelp", index, page)

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
	reload()

func reload():
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
	
	var reroller = Save.importSave(Enums.SaveFlag.U_REROLL, 0);
	if reroller > ascention_reroller_value:
		ascention_reroller_value = reroller
	Save.exportSave(Enums.SaveFlag.U_REROLL, ascention_reroller_value);
	apply_dragon_upgrades()

func get_destroyer_time_remaining_epoch(_upgrades = null):
	var fight_start_epoch = Save.importSave(Enums.SaveFlag.DES_FIGHT_START_EPOCH, 0, true)
	var upgrades = _upgrades if _upgrades else Save.importSave(Enums.SaveFlag.DES_ADD_DICE, 0, true)
	var u = upgrades - SIMULATED_UPGRADES
	var total_duration = EPOCH_THOUSAND_YEARS
	
	# Halve the duration based on real upgrades
	for i in range(u):
		total_duration /= 2.0
	
	# TODO: must use fight_start_epoch to retain fight time, if using now() it will always halve it, thus punish when you take longer with the fight.
	# For 'flavour' below ~15 mins the fight should use now() instead to show the timer ticking down
	return fight_start_epoch + total_duration - 172800 - 64800 - 2400 # minus 2 days, 18 hours, 40 minutes

func apply_dragon_upgrades():
	du_bounty_multiplier = (4 * sum_save_flag_array([
		Enums.SaveFlag.DRG_1,
		Enums.SaveFlag.DRG_2,
		Enums.SaveFlag.DRG_3,
		Enums.SaveFlag.DRG_4,
		Enums.SaveFlag.DRG_5,
		Enums.SaveFlag.DRG_6,
		Enums.SaveFlag.DRG_7,
		Enums.SaveFlag.DRG_8,
	]))
	du_feather_multiplier = (2 * sum_save_flag_array([
		Enums.SaveFlag.DRG_9,
		Enums.SaveFlag.DRG_10,
		Enums.SaveFlag.DRG_11,
		Enums.SaveFlag.DRG_12,
		Enums.SaveFlag.DRG_13,
	]))
	du_s_feather_multiplier = (4 * sum_save_flag_array([
		Enums.SaveFlag.DRG_14,
		Enums.SaveFlag.DRG_15,
		Enums.SaveFlag.DRG_16,
		Enums.SaveFlag.DRG_17,
	]))
	du_add_dice_max = true if Save.importSave(Enums.SaveFlag.DRG_18, false) != 0 else false
	du_dm_max = true if Save.importSave(Enums.SaveFlag.DRG_19, false) != 0 else false
	du_add_dice_max = true if Save.importSave(Enums.SaveFlag.DRG_20, false) != 0 else false

func sum_save_flag_array(save_flags: Array):
	var output: int = 0
	for s in save_flags:
		output += Save.importSave(s, 0)
	return output
