extends Resource
class_name Upgrade

signal updated

export var max_level = 20
export var base_price = 5
export var levelup_price_increase: int = 10;
export var levelup_price_percent_increase: int = 10;

var price = 0
var level = 0

func levelUp() -> bool:
	if tryLevelUp() == false:
		return false
	
	print("override this")
	return true

func tryLevelUp():
	if(Globals.currency < price):
		return false
	if(max_level != -1):
		if(level >= max_level):
			return false
			
	Globals.removeCurrency(price)
	level = level + 1
	price =+ calculatePriceIncrease(price,levelup_price_increase,levelup_price_percent_increase)
	
	emit_signal("updated")
	return true

func calculatePriceIncrease(_current_price, _price_increase_value, _price_increase_percent):
	var output = _current_price + _price_increase_value
	var increase: float = 0
	if(_price_increase_percent != 0):
		increase = (float(output) / float(100)) * float(_price_increase_percent)
	output = output + ceil(increase)
	return output

func tryImportSave():
	if Globals.upgrade_save_overrides == null:
		return false
	var save = Globals.upgrade_save_overrides.split("/")
	
	print("override this")
	return true

func exportSave():
	return int(level)
