extends Control

export(String, MULTILINE) var title = "Upgrade Name"
export(String, MULTILINE) var description = "Help text"
export(Texture) var icon = load("res://assets/sprites/upgrades/Hexagram.png")

export(Enums.SaveFlag) var unlock_flag
export var upgrade_price = 10;

var unlocked

func _ready():
	Globals.connect("dFeathersUpdated", self, "render")
	$Label.text = title;
	$TextureRect.texture = icon
	unlocked = bool(Save.importSave(unlock_flag, 0) > 0)
	render(0)
	
func render(x):
	$HBoxContainer/Label.text = str(upgrade_price)
	if Globals.dFeathers < upgrade_price:
		$ThemeButton.modulate = Color(1,1,1,.5)
	if unlocked == true:
		$HBoxContainer.modulate = Color(1,1,1,.5)
		$ThemeButton.modulate = Color(1,1,1,.5)
		$ThemeButton.button_text = "Unlocked!"
	
func _on_ThemeButton_button_clicked():
	if unlocked:
		return
		
	if Globals.dFeathers >= upgrade_price:
		unlocked = true
		Globals.dFeathers -= upgrade_price
		Save.exportSave(unlock_flag, 1)
		render(0)
