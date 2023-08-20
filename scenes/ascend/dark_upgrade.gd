extends Control

export(String, MULTILINE) var title = "Upgrade Name"
export(Texture) var icon = load("res://assets/sprites/upgrades/Hexagram.png")
export var help_index = -1
export var help_page = "upgrades"

export(Enums.SaveFlag) var unlock_flag
export var upgrade_price = 10;

var unlocked

func _ready():
	var _a = Globals.connect("dFeathersUpdated", self, "render")
	$Label.text = title;
	$TextureRect.texture = icon
	unlocked = bool(Save.importSave(unlock_flag, 0) > 0)
	render(0)
	$TextureRect/Help.help_index = help_index
	$TextureRect/Help.help_page = help_page
	
func render(_x):
	$HBoxContainer/Label.text = str(upgrade_price)
	if Globals.dFeathers < upgrade_price:
		$ThemeButton.modulate = Color(1,1,1,.5)
	if unlocked == true:
		$ThemeButton.visible = false
		$HBoxContainer.visible = false
		$unlocked.visible = true
	
func _on_ThemeButton_button_clicked():
	if unlocked:
		return
		
	if Globals.dFeathers >= upgrade_price:
		unlocked = true
		Globals.dFeathers -= upgrade_price
		Save.exportSave(unlock_flag, 1)
		render(0)
