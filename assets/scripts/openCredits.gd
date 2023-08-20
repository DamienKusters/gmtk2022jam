extends Control

func _on_ThemeButton2_button_clicked():
	$"../Options".visible = true;

func _on_ThemeButton_button_clicked():
	Globals.openHelp(0, "credits")
