extends Button

onready var g = $"/root/Globals";

func _on_Help_button_down():
	var p = get_parent();
	g.openHelp(p.spriteTexture, p.title, p.description);
	pass # Replace with function body.
