extends Node2D

onready var g = $"/root/Globals";

func _ready():
	var t = Tween.new();
	add_child(t);
	t.interpolate_property(self, "modulate", Color('000'),Color('fff'), 2, Tween.TRANS_QUINT, Tween.EASE_IN);
	t.interpolate_property($CanvasLayer/Ui, "modulate", Color('00ffffff'),Color('fff'), 3.5, Tween.TRANS_QUINT, Tween.EASE_IN);
	t.start();
	g.connect("feathersUpdated", self, "updateFeathers");
	updateFeathers(g.feathers);

func updateFeathers(value):
	$CanvasLayer/Ui/HBoxContainer/LabelFeathers.text = "x " + String(value);


func _on_Button_pressed():
	g.ascendReset();
	var e = get_tree().change_scene("res://scenes/main.tscn");
