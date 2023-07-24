extends Upgrade
class_name AddDiceUpgrade

func _init():
	base_price = 5
	price = base_price
	levelup_price_increase = 5
	levelup_price_percent_increase = 11
	max_level = 20

func levelUp() -> bool:
	if tryLevelUp() == false:
		return false
	
	Globals.addDice();
	return true

func tryImportSave():
	if Globals.upgrade_save_overrides == null:
		return false
	var save = Globals.upgrade_save_overrides.split("/")
	
	level = int(save[0]);
	for i in level:
		price =+ calculatePriceIncrease(price,levelup_price_increase,levelup_price_percent_increase);
