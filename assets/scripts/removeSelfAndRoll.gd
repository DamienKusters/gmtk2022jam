extends Control

func _ready():
	visible = Save.save == {}

func _on_Button_button_down():
	visible = false;
	Globals.emit_signal("rollRandomDice")
