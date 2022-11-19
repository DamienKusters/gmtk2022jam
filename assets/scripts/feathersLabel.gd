extends Label

onready var g = $"/root/Globals";

func _ready():
	g.connect("feathersUpdated", self, "updateFeathers");
	text = "x " + String(g.feathers);
	pass

func updateFeathers(value: int):
	text = "x " + String(value);
