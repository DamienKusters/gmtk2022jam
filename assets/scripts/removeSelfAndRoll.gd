extends Control

onready var g = $"/root/Globals";

func _ready():
	if (g.currency == 0 && g.feathers == 0) == false:
		visible = false;
	else:
		visible = true;

func _on_Button_button_down():
	visible = false;
	g.rollRandomDice();
