extends Control

func _ready():
	#TODO: fix
	visible = Save.importSave(Enums.SaveFlag.CURRENCY, 0) == 0

func _on_Button_button_down():
	visible = false;
	Globals.emit_signal("rollRandomDice")
