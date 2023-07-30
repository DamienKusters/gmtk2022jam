tool
extends Control

onready var particle = preload("res://scenes/shared/single_particle_effect.tscn");

export(Enums.Upgrade) var upgrade_type
export(String) var title: String = "Upgrade Name" setget setTitle
export(Color) var background_color = Color("966833") setget setBackgroundColor # Dark: 6A4F76
export(Texture) var texture = load("res://assets/sprites/upgrades/Contract.png")

var upgrade
var locked = false setget setLocked

func setTitle(value):
	title = value
	$"%LabelTitle".text = value

func setBackgroundColor(value):
	background_color = value
	$NinePatchRect.self_modulate = value

func setLocked(value):
	locked = value
	$"%LabelPrice".visible = !locked

func _ready():
	$"%UpgradeIcon".texture = texture
	
#	upgrade = model.upgrade_resource
#	upgrade.tryImportSave()
#	updateUi()
#	upgrade.connect("updated", self, "upgradeUpdated")
#	if upgrade.has_method("_setTargetEnemy"):
#		upgrade.connect("set_contract", self, "setContract")
#		upgrade.connect("complete_contract", self, "removeContract")
#		setContract()
	pass

# relocate
func setContract():
	$TargetEnemy.texture = upgrade.target_enemy.sprite
	$Tween.setTarget()
	setLocked(true)

# relocate
func removeContract():
	print("remove")
	$Tween.removeTarget()
	setLocked(false)

func updateUi():
	if(upgrade.max_level != -1 && (upgrade.level >= upgrade.max_level)):
		$"%LabelPrice".visible = false
	$"%LabelPrice".text = str(upgrade.price)
	if upgrade.level >= upgrade.max_level:
		$"%LabelLevel".text = "max"
		$"%LabelPrice".visible = false
		$Tween.collapse()
	elif(upgrade.level > 0):
		$"%LabelLevel".text = str(upgrade.level);
	else:
		$"%LabelLevel".text = "";

#TODO: remove
func setPayable(value):
	if(value >= upgrade.price):
		$"%LabelPrice".add_color_override("font_color", Color("d8d400"));
	else:
		$"%LabelPrice".add_color_override("font_color", Color("d83300"));

func upgradeUpdated():
	setPayable(Globals.currency);
	updateUi()
	Save.exportSave(Enums.SaveFlag.U_ADD_DICE, upgrade.level)
	Save.saveGame()

func onPressed():
	return
	
	
	if locked:
		return
	var success = upgrade.levelUp()
	if success:
		$particle_point.add_child(particle.instance());
		$AudioStreamPlayer.play()
