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
				exportAllSaves();
				return;
			idx += 1;
		diceKind += 1;
	print("none can be upgraded");

func exportAllSaves():
	var dice = get_children();
	var save = "";
	var i = 0;
	for d in dice:
		save += d.exportSave();
		if i != dice.size()-1:
			save += "/";
		i+=1;
	Globals.upgradeDiceOverridesUpdated(save);
	print(save);
	return save;
	
func add_dice(dice):
	add_child(dice);
	exportAllSaves();
