extends Control

func _ready():
	if (Globals.currency == 0 && Globals.feathers == 0 && Globals.ascention_dps_multiplier_value == 1 && Globals.ascention_dps_multiplier_level == 0) == false:
		visible = false;
	else:
		visible = true;

func _on_Button_button_down():
	visible = false;
	Globals.rollRandomDice();
