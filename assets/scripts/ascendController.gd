extends Control

func _ready():
	$ui/fader/angelic.visible = false
	$ui/fader/dark.visible = false

func ascend():
	Save.exportSave(Enums.SaveFlag.CURRENCY, Globals.featherValue * (10 * Globals.feathers))
	Save.exportSave(Enums.SaveFlag.FEATHERS, 0)
	Save.exportSave(Enums.SaveFlag.U_ADD_DICE, 0)
	Save.exportSave(Enums.SaveFlag.U_UPGRADE_DICE, 0)
	Save.exportSave(Enums.SaveFlag.U_DUNGEON_MASTER, 0)
	Save.exportSave(Enums.SaveFlag.U_DICE_TOWER, 0)
	Save.exportSave(Enums.SaveFlag.U_REROLL, 0)
	Save.exportSave(Enums.SaveFlag.U_CONTRACT, 0)
	Save.exportSave(Enums.SaveFlag.U_ENHANCE_DICE, 0)
	Save.exportSave(Enums.SaveFlag.U_QUICKROLL, 0)
	Save.exportSave(Enums.SaveFlag.U_HEXAGRAM, 0)
	Save.exportSave(Enums.SaveFlag.U_OVERDRIVE, 0)
	Save.exportSave(Enums.SaveFlag.U_SUPER_REROLL, 0)
	Save.exportSave(Enums.SaveFlag.DICE, 0)
	Save.exportSave(Enums.SaveFlag.TARGET_ENEMY_BEATEN, 0)
	
	Globals._init()
	
	Save.saveGame()
	var _a = get_tree().change_scene("res://scenes/main.tscn");

func showMenu():
	$ui/MenuNavigator.play("show_menu")
	$ui/fader/angelic.visible = false
	$ui/fader/dark.visible = false

func _on_upgrades_pressed(id: int):
	$ui/MenuNavigator.play("hide_menu")
	
	match(id):
		0:
			$ui/fader/angelic.visible = true
		1:
			$ui/fader/dark.visible = true
