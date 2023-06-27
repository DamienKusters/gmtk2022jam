extends Control

onready var particle = preload("res://scenes/shared/single_particle_effect.tscn");

export(Enums.Upgrade) var upgrade_type
export var background_color = Color("966833") setget setBackgroundColor

var model
var upgrade;

func setBackgroundColor(value):
	background_color = value
	$NinePatchRect.self_modulate = value

func _ready():
	model = Globals.upgrades[upgrade_type]
	$NinePatchRect/HBoxContainer/VBoxContainer/LabelTitle.text = model.title
	$NinePatchRect/HBoxContainer/Control/TextureRect.texture = model.texture;
	
	upgrade = model.upgrade_resource
	updateUi()

func updateUi():
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

func onPressed():
	var success = upgrade.levelUp()
	if success:
		$particle_point.add_child(particle.instance());
		$AudioStreamPlayer.play()
		if(upgrade.max_level != -1):
			if(upgrade.level >= upgrade.max_level):
				$"%LabelPrice".visible = false
		
		setPayable(Globals.currency);
		updateUi()
		Globals.saveGame()

func _on_HelpButton_button_down():
	Globals.openHelp(model.texture, model.title, model.description);
