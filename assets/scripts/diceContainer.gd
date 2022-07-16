extends Node2D

onready var g = $"/root/Globals";

var rng = RandomNumberGenerator.new();

const badCoding = preload("res://scenes/dice.tscn");

func _ready():
	g.connect("rollRandomDice", self, "rollRandomNonRollingDice");
	g.connect("upgradeDice", self, "upgradeDice");
	pass

func rollRandomNonRollingDice():
	rng.randomize();
	
	var dice = get_children()[rng.randi_range(0,get_child_count()-1)];
	
	if(dice.rolling == false):
		dice.roll();
	pass
	
func upgradeDice():
	var dice = get_children();
	
	var idx = 0;
	var diceKind = 0; # starts at d3;
	while(diceKind <= 5):
		for d in dice:
			if(d.kind == diceKind):
				remove_child(d);
				var replaceDice = badCoding.instance();
				replaceDice.kind = d.kind + 1;
				replaceDice.position = d.position;
				add_child(replaceDice);
				move_child(replaceDice,idx);
				return;
			idx += 1;
		diceKind += 1;
