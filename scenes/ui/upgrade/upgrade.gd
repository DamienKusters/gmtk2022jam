extends Control

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
	if upgrade.level >= upgrade.max_level:
		$NinePatchRect/HBoxContainer/Control2/LabelLevel.text = "max"
		$NinePatchRect/HBoxContainer/VBoxContainer/LabelPrice.visible = false
		$Tween.collapse()
	elif(upgrade.level > 0):
		$NinePatchRect/HBoxContainer/Control2/LabelLevel.text = str(upgrade.level);
	else:
		$NinePatchRect/HBoxContainer/Control2/LabelLevel.text = "";

func onPressed():
	var success = upgrade.levelUp()
	if success:
		$AudioStreamPlayer.play();
		updateUi()
		Globals.saveGame();

func _on_HelpButton_button_down():
	Globals.openHelp(model.texture, model.title, model.description);
