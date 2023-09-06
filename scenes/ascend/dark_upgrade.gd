extends Control

export var database_upgrade_ref = "add_dice"
export(Enums.SaveFlag) var unlock_flag
export var upgrade_price = 10;

var unlocked

func _ready():
	var _a = Globals.connect("dFeathersUpdated", self, "render")
	$Label.text = Database.upgrades[database_upgrade_ref]['name'];
	$TextureRect.texture = Database.upgrades[database_upgrade_ref]['icon'];
	unlocked = bool(Save.importSave(unlock_flag, 0) > 0)
	render(0)
	$TextureRect/Help.help_index = Database.upgrades[database_upgrade_ref]['helpIndex'];
	$TextureRect/Help.help_page = "upgrades"
	
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
