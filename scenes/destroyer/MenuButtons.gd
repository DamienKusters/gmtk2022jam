extends HBoxContainer

func _on_back_button_clicked():
	var _e = get_tree().change_scene("res://scenes/ascend/ascend.tscn");

func _on_help_button_clicked():
	Globals.openHelp(0, "destroyer")
