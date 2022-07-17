extends TextureRect

func _on_Button_button_down():
	get_parent().remove_child(self);
