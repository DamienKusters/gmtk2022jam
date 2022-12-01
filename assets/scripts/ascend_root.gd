extends Node2D

func _ready():
	var t = Tween.new();
	add_child(t);
	t.interpolate_property(self, "modulate", Color('000'),Color('fff'), 2, Tween.TRANS_QUINT, Tween.EASE_IN);
	t.interpolate_property($CanvasLayer/Ui, "modulate", Color('00ffffff'),Color('fff'), 3.5, Tween.TRANS_QUINT, Tween.EASE_IN);
	t.start();
	Globals.connect("feathersUpdated", self, "updateFeathers");
	updateFeathers(Globals.feathers);

func updateFeathers(value):
	$CanvasLayer/Ui/HBoxContainer/LabelFeathers.text = "x " + String(value);

func _on_Button_pressed():
	Globals.ascendReset();
	var e = get_tree().change_scene("res://scenes/main.tscn");

func _temp():
	var save = $CanvasLayer/Ui/TextEdit.text;
	var cut = save.split("|");
	$CanvasLayer/Ui/ColorRect/VBoxContainer/HBoxContainer/AscentionDiceButton.resource.importResource(cut[0]);
	$CanvasLayer/Ui/ColorRect/VBoxContainer/HBoxContainer2/AscentionDiceButton.resource.importResource(cut[1]);
	pass # Replace with function body.
