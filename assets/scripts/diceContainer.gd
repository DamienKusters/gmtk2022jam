extends Node2D

onready var g = $"/root/Globals";

var rng = RandomNumberGenerator.new();

func _ready():
	g.connect("rollRandomDice", self, "rollRandomNonRollingDice");
	pass

func rollRandomNonRollingDice():
	rng.randomize();
	
	var dice = get_children()[rng.randi_range(0,get_child_count()-1)];
	
	if(dice.rolling == false):
		dice.roll();
	pass
