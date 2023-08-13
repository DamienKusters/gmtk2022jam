extends Node

export(bool) var super_upgrade = false
export(Enums.SaveFlag) var save_flag_check
export var player: NodePath = ''

onready var uNormal = get_child(0)
onready var uSuper = get_child(1)

func setSuperUpgrade(value):
	super_upgrade = value
	uNormal.visible = !super_upgrade
	uSuper.visible = super_upgrade
	
func _ready():
	uNormal.visible = true
	uSuper.visible = false
	uNormal.connect("levelChanged", self, "levelChanged", [true])
	levelChanged(false)
	
func levelChanged(shadowUpgradeSpawn):
	if Save.importSave(save_flag_check, 0) > 0:#TODO: Fix
		if uNormal.level >= uNormal.levelCap:
			super_upgrade = true
			uNormal.visible = !super_upgrade
			uSuper.visible = super_upgrade
			if player != '' && shadowUpgradeSpawn:
				get_node(player).playRandomPitch()
				uSuper.shadowUpgradeSpawn()
