extends Label

onready var g = $"/root/Globals";

func _ready():
	g.connect("currencyUpdated", self, "updateCurrency");
	text = "$0";
	pass

func updateCurrency(value: int):
	text = "$" + String(value);
