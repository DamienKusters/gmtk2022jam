extends Label

func _ready():
	var dps = Globals.ascention_dps_multiplier_value;
	if dps > 1:
		text = "Damage: x" + str(Globals.ascention_dps_multiplier_value);
