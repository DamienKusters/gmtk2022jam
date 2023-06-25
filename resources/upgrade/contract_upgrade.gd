extends Upgrade
class_name ContractUpgrade

signal set_contract
signal complete_contract

var target_enemy: EnemyModel;

func _init():
	tryImportSave(Globals.upgrade_save_overrides)
	Globals.connect("enemyKilled", self, "enemyKilled")
	max_level = Globals.enemy_pool.size() - 1
	_setTargetEnemy()

func _setTargetEnemy():
	target_enemy = Globals.enemy_pool[Globals.contractLevel].enemy_pool.back()
	emit_signal("set_contract")

func levelUp() -> bool:
	if level >= max_level:
		return false
	Globals.upgradeEnemyPool();
	level += 1
	_setTargetEnemy()
	return true

func enemyKilled(enemy):
	if Globals.contractLevel < max_level:#TODO: contractlevel to local var?
		if enemy == target_enemy:
			emit_signal("complete_contract")

func tryImportSave(saveString):
	if saveString == null:
		return false
	var save = saveString.split("/")
	Globals.contractLevel = int(save[5])
	_setTargetEnemy()
