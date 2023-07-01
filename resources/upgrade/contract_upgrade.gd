extends Upgrade
class_name ContractUpgrade

signal set_contract
signal complete_contract

var target_enemy: EnemyModel;

func _init():
	Globals.connect("enemyKilled", self, "enemyKilled")
	base_price = 50
	price = base_price
	levelup_price_increase = 120
	levelup_price_percent_increase = 37
	max_level = Globals.enemy_pool.size() - 1
	_setTargetEnemy()

func _setTargetEnemy():
	target_enemy = Globals.enemy_pool[Globals.contractLevel].enemy_pool.back()
	emit_signal("set_contract")

func levelUp() -> bool:
	if tryLevelUp() == false:
		return false
	Globals.upgradeEnemyPool()
	_setTargetEnemy()
	return true

func enemyKilled(enemy):
	if Globals.contractLevel < max_level:#TODO: contractlevel to local var?
		if enemy == target_enemy:
			emit_signal("complete_contract")
			target_enemy = null

func tryImportSave():
	if Globals.upgrade_save_overrides == null:
		return false
	var save = Globals.upgrade_save_overrides.split("/")
	Globals.contractLevel = int(save[5])
	_setTargetEnemy()
	
	level = int(save[5]);
	for i in level:
		price =+ calculatePriceIncrease(price,levelup_price_increase,levelup_price_percent_increase);
