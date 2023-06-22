class_name Contract

var max_contract_level;
var target_enemy;

func _init():
	tryImportSave(Globals.upgrade_save_overrides)
	Globals.connect("enemyKilled", self, "enemyKilled")
	max_contract_level = Globals.enemy_pool.size() - 1
	_setTargetEnemy()

func _setTargetEnemy():
	target_enemy = Globals.enemy_pool[Globals.contractLevel].enemy_pool.back()

func enemyKilled(enemy):
	if Globals.contractLevel < max_contract_level:#TODO: contractlevel to local var?
		if enemy == target_enemy:
			#TODO: event here for parent implementation???
			Globals.upgradeEnemyPool()#TODO: Only upgrade after player purchase
			_setTargetEnemy()

func tryImportSave(saveString):
	if saveString == null:
		return false
	var save = saveString.split("/")
	Globals.contractLevel = int(save[5])
	_setTargetEnemy()
