extends Button

func _on_Help_button_down():
	var p = get_parent();
	Globals.openHelp(p.spriteTexture, p.title, p.description);
