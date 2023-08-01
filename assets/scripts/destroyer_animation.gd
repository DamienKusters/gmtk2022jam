extends Node

func _ready():
	if Save.importSave(Enums.SaveFlag.DESTROYER_SPAWNED, 0) > 0:
		$AnimationPlayer.play("hover")
		return
	if Save.importSave(Enums.SaveFlag.BOLTS, 0) > 0:
		$AnimationTree.active = true
		Save.exportSave(Enums.SaveFlag.DESTROYER_SPAWNED, 1)
		#Calling save game is dangerous in ascention
		Save.saveGame()
		return
