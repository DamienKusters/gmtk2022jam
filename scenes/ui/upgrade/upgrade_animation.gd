extends Tween

export var animation_speed = 1

func collapse():
	var t1 = $"../NinePatchRect"
	interpolate_property(t1, "margin_left", t1.margin_left, 261, animation_speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT);
	
	var t2 = $"../NinePatchRect/HBoxContainer/VBoxContainer"
	interpolate_property(t2, "modulate", t2.modulate, Color("00ffffff"), animation_speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT);
	start();

func expand():
	var t1 = $"../NinePatchRect"
	interpolate_property(t1, "margin_left", t1.margin_left, 0, animation_speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT);
	
	var t2 = $"../NinePatchRect/HBoxContainer/VBoxContainer"
	interpolate_property(t2, "modulate", t2.modulate, Color("ffffffff"), animation_speed, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT);
	start();
