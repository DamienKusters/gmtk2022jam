extends Node2D

onready var particle = preload("res://scenes/shared/single_particle_effect_harvest.tscn")

var rng = RandomNumberGenerator.new()
var currentSpot = 0

func _ready():
	var _a = Globals.connect("rollRandomDice", self, "rollRandomNonRollingDice")
	var _b = Globals.connect("upgradeDice", self, "upgradeDice")
	var _c = Globals.connect("deleteDice", self, "deleteDice")
	var _d = Globals.connect("addDice", self, "addDice")
	
	var initDice = Save.importSave(Enums.SaveFlag.U_ADD_DICE, 0) - Save.importSave(Enums.SaveFlag.U_DELETE_DICE, 0)
	var diceLevels = Save.importSave(Enums.SaveFlag.DICE, "000000000000000000000", false)
	for d in initDice+1:
		var level = 0
		if diceLevels[d] != null:
			level = diceLevels[d]
		addDice(level)
	exportAllSaves()

func rollRandomNonRollingDice():
	var dice = get_children();
	
	for d in dice:
		if(d.rolling == false):
			d.roll();
			return;

func addDice(type):
	if(currentSpot == 21):
		return
	get_child(currentSpot).updateDice(type as int)
	currentSpot = currentSpot + 1

func upgradeDice(enhanced):
	var dice = get_children();
	
	var idx = 0
	var diceKind = 0 # starts at d4;
	var maxUpgr = 4
	if enhanced:
		maxUpgr = 5
		diceKind = 5
	while(diceKind <= maxUpgr):
		for d in dice:
			if(d.active == true && d.kind == diceKind):
				d.updateDice(d.kind + 1)
				Globals.emit_signal("upgradeDiceSuccess", enhanced)
				exportAllSaves()
				return
			idx += 1
		diceKind += 1
	print("none can be upgraded");

func exportAllSaves():
	var dice = get_children();
	var save = "";
	var i = 0;
	for d in dice:
		save += d.exportSave();
		if i != dice.size()-1:
			save += "";
		i+=1;
	Save.exportSave(Enums.SaveFlag.DICE, save)
	return save;
	
func add_dice(dice):
	add_child(dice)
	exportAllSaves()
#	Save.saveGame()# ADD DICE NOT SAVING CORRECTLY WHEN DOING INFNIITE BUY

func deleteDice():
	var d = get_children().back()
	match(d.maxVal):
		100:
			Globals.bolts += 1
			var p = particle.instance()
			p.amount = 1
			p.texture = load("res://assets/sprites/icons/bolt.png")
			p.position = d.global_position
			$"..".add_child(p)
		20:
			Globals.dFeathers += 2
			var p = particle.instance()
			p.amount = 2
			p.texture = load("res://assets/sprites/icons/demon_feather.png")
			p.position = d.global_position
			$"..".add_child(p)
		_:
			var amount = (d.maxVal / 2) - 1
			Globals.addFeathers(amount)
			var p = particle.instance()
			p.amount = amount
			p.position = d.global_position
			$"..".add_child(p)
	remove_child(d)
	exportAllSaves()
