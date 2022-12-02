extends Node2D

onready var g = $"/root/Globals";

var rng = RandomNumberGenerator.new();

const badCoding = preload("res://scenes/dice.tscn");

func _ready():
	g.connect("rollRandomDice", self, "rollRandomNonRollingDice");
	g.connect("upgradeDice", self, "upgradeDice");

func rollRandomNonRollingDice():
	var dice = get_children();
	
	for d in dice:
		if(d.rolling == false):
			d.roll();
			return;
	
func upgradeDice():
	var dice = get_children();
	
	var idx = 0;
	var diceKind = 0; # starts at d3;
	while(diceKind <= 4):
		for d in dice:
			if(d.kind == diceKind):
				remove_child(d);
				var replaceDice = badCoding.instance();
				replaceDice.kind = d.kind + 1;
				replaceDice.position = d.position;
				add_child(replaceDice);
				move_child(replaceDice,idx);# TODO: Fix
				g.upgradeDiceSuccess();
				return;
			idx += 1;
		diceKind += 1;
	print("none can be upgraded");
