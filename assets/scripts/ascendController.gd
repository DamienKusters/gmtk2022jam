extends Control

var _bolts
var _dfeathers

func _ready():
	_bolts = Save.importSave(Enums.SaveFlag.BOLTS, 0)
	_dfeathers = Save.importSave(Enums.SaveFlag.DEMON_FEATHERS, 0)
	Save.resetSave()
	# Or clever reset save (only flags you pass in)
	#TODO: add all payment things back
	#TOOD: add all ascention upgrades back

func ascend():
	Save.exportSave(Enums.SaveFlag.BOLTS, _bolts)
	Save.saveGame()

func showMenu():
	$ui/MenuNavigator.play("show_menu")

func _on_upgrades_pressed(id: int):
	$ui/MenuNavigator.play("hide_menu")
