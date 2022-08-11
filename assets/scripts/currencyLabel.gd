extends Label

onready var g = $"/root/Globals";

func _ready():
	g.connect("currencyUpdated", self, "updateCurrency");
	text = "" + String(g.currency);
	pass

func updateCurrency(value: int):
	text = "" + String(value);
