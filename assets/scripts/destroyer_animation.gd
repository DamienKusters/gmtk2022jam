extends Node

onready var destroyer_button: Control = $"../../../ui/menu/Node2"

func _ready():
	destroyer_button.visible = false
	if Save.importSave(Enums.SaveFlag.DESTROYER_SPAWNED, 0) > 0:
		$AnimationPlayer.play("hover")
		destroyer_button.visible = true
		return
	if Save.importSave(Enums.SaveFlag.BOLTS, 0) > 0:
		$AnimationTree.active = true
		destroyer_button.visible = false
		$Timer.start()
		Save.exportSave(Enums.SaveFlag.DESTROYER_SPAWNED, 1)
		return

func triggerDestroyerShowButton():
	destroyer_button.visible = true
