extends Button

func _on_Button_button_down():
	$"../About".visible = true;

func _on_ThemeButton2_button_clicked():
	$"../Options".visible = true;
