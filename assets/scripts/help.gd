extends "res://assets/scripts/removeSelf.gd"

onready var g = $"/root/Globals";

func _ready():
	g.connect("openHelp", self, "openHelp");

func openHelp(obj):
	$TextureRect/TextureRect.texture = obj["texture"];
	$TextureRect/TextureRect/Title.text = obj["title"];
	$TextureRect/TextureRect/Title2.text = obj["description"];
	visible = true;
	pass
