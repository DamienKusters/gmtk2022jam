extends Label



func _ready():
	g.connect("feathersUpdated", self, "updateFeathers");
	text = str(g.feathers);

func updateFeathers(value: int):
	text = str(value);
