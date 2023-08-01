extends Node

func _ready():
	if Save.importSave(Enums.SaveFlag.DESTROYER_SPAWNED, 0) > 0:
		$bg.visible = false
		$bg2.visible = true
