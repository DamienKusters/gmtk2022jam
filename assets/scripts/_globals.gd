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
var currency = 999999999999990
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
	
	currency = Save.importSave(Enums.SaveFlag.CURRENCY, 0);
	feathers = Save.importSave(Enums.SaveFlag.FEATHERS, 0);
	
	upgrade_save_overrides = s[2];
	
	var a_dps = s[3].split("/");
	ascention_dps_multiplier_value = Save.importSave(Enums.SaveFlag.A_MULTIPLIER_VALUE, 1);
	ascention_dps_multiplier_level = Save.importSave(Enums.SaveFlag.A_MULTIPLIER_LEVEL, 0);
	var a_reroll = s[4].split("/");
	ascention_reroller_value = Save.importSave(Enums.SaveFlag.A_REROLL_VALUE, 0);
	ascention_reroller_level = Save.importSave(Enums.SaveFlag.A_REROLL_LEVEL, 0);
	
	upgrade_dice_overrides = s[5];
	
	pass

func _init():
	contractLevel = 0;
	autoImportSave();

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
