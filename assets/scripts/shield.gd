extends TextureRect

onready var g = $"/root/Globals";

func _ready():
	pass

func setData(dice):
	var data = g.getDiceData(dice);
	self_modulate = data['color'];
	$Label.text = "D"+str(data['value']);
