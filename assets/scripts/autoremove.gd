extends Node

export var time = .5;

func _ready():
	yield(get_tree().create_timer(time), "timeout");
	queue_free();
