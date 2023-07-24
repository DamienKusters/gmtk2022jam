tool
extends NinePatchRect

export var button_text = "Button" setget setButton;
export var modulate_default = Color("412d17") setget setColour;
export var modulate_hover = Color("966833");

signal button_clicked;

func setButton(value):
	button_text = value;
	$Button.text = value;
	
func setColour(value):
	self_modulate = value;
	modulate_default = value;

func _ready():
	self_modulate = modulate_default;

func _on_Button_mouse_entered():
	$Tween.stop_all();
	$Tween.interpolate_property(self, "self_modulate", self_modulate, modulate_hover, .2);
	$Tween.start();

func _on_Button_mouse_exited():
	$Tween.stop_all();
	$Tween.interpolate_property(self, "self_modulate", self_modulate, modulate_default, .2);
	$Tween.start();

func _on_Button_pressed():
	emit_signal("button_clicked");
