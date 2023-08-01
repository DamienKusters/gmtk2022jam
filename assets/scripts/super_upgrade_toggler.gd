tool
extends Node

export(bool) var super_upgrade = false
export(Enums.SaveFlag) var save_flag_check

onready var uNormal = get_child(0)
onready var uSuper = get_child(1)

func setSuperUpgrade(value):
	super_upgrade = value
	get_child(0).visible = !super_upgrade
	get_child(1).visible = super_upgrade
	
func _ready():
	uNormal.connect("levelChanged", self, "levelChanged")
	levelChanged()
	
func levelChanged():
	if Save.importSave(save_flag_check, 0) > 0:
		if uNormal.level >= uNormal.levelCap:
			super_upgrade = true
			get_child(0).visible = !super_upgrade
			get_child(1).visible = super_upgrade
