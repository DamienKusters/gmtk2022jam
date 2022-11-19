extends Node2D


func _ready():
	var t = Tween.new();
	add_child(t);
	t.interpolate_property(self, "modulate", Color('000'),Color('fff'), 2, Tween.TRANS_QUINT, Tween.EASE_IN);
	t.interpolate_property($CanvasLayer/Ui, "modulate", Color('00ffffff'),Color('fff'), 4, Tween.TRANS_QUINT, Tween.EASE_IN);
	t.start();
	pass
