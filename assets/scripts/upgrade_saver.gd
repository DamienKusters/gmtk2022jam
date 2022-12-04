extends Control

onready var upgrades = [
	$VBoxContainer/u_add,
	$VBoxContainer/u_upgrade,
	$VBoxContainer/u_dm,
	$VBoxContainer/u_rolltime,
	$VBoxContainer/u_reroll,
	$VBoxContainer/u_contract,
];

func _ready():
	for u in upgrades:
		u.connect("levelChanged",self,"exportAllSaves");
	exportAllSaves();
	pass

func exportAllSaves():
	var save = "";
	var i = 0;
	for u in upgrades:
		save += u.exportSave();
		if i != upgrades.size()-1:
			save += "/";
		i+=1;
	Globals.upgradeSavesUpdated(save);
	return save;
	
func importAllSaves(save):
	pass
