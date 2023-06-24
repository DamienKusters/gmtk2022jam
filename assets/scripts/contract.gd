extends Resource
class_name Contract

signal set_contract
signal complete_contract

var max_contract_level;
var target_enemy: EnemyModel;

func _init():
	tryImportSave(Globals.upgrade_save_overrides)
	Globals.connect("enemyKilled", self, "enemyKilled")
	max_contract_level = Globals.enemy_pool.size() - 1
	_setTargetEnemy()

func _setTargetEnemy():
	target_enemy = Globals.enemy_pool[Globals.contractLevel].enemy_pool.back()
	emit_signal("set_contract")

func levelUp():
	Globals.upgradeEnemyPool();
	_setTargetEnemy()

func enemyKilled(enemy):
	if Globals.contractLevel < max_contract_level:#TODO: contractlevel to local var?
		if enemy == target_enemy:
			emit_signal("complete_contract")

func tryImportSave(saveString):
	if saveString == null:
		return false
	var save = saveString.split("/")
	Globals.contractLevel = int(save[5])
	_setTargetEnemy()
