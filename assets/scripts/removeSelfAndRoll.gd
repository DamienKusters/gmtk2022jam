extends Control

onready var g = $"/root/Globals";

func _on_Button_button_down():
	visible = false;
	g.rollRandomDice();
