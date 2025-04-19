extends VBoxContainer

const COST_MULTIPLIER = 3
const PERCENTAGE_REWARD = 5
const PERCENTAGE_LIMIT = 90

var upgrade_cost

func _ready():
	var _a = Globals.connect("boltsUpdated", self, 'render')
	var current_chance = Save.importSave(Enums.SaveFlag.HARVEST_DICE_BOLT_CHANCE, 0)
	upgrade_cost = floor((current_chance+1) * COST_MULTIPLIER)
	render(0)
	renderVisibility()

func _on_ConvertButton_button_clicked():
	var bolts = Save.importSave(Enums.SaveFlag.BOLTS, 0)
	var current_chance = Save.importSave(Enums.SaveFlag.HARVEST_DICE_BOLT_CHANCE, 0)
	upgrade_cost = floor((current_chance+1) * COST_MULTIPLIER)
	
	if (Globals.bolts >= upgrade_cost) == false:
		return
	Globals.bolts -= upgrade_cost
	var chance = Save.importSave(Enums.SaveFlag.HARVEST_DICE_BOLT_CHANCE, 0)
	Save.exportSave(Enums.SaveFlag.HARVEST_DICE_BOLT_CHANCE, chance + PERCENTAGE_REWARD)
	render(0)

func render(_a):
	$ConvertButton.visible = Save.importSave(Enums.SaveFlag.HARVEST_DICE_BOLT_CHANCE, 0) < PERCENTAGE_LIMIT
	$ConvertButton/VBoxContainer/HBoxContainer/Label.text = str(upgrade_cost)
	$HBoxContainer/Label.text = "Current chance: " + str(Save.importSave(Enums.SaveFlag.HARVEST_DICE_BOLT_CHANCE, 0)) + "%"

func renderVisibility():
	visible = Save.importSave(Enums.SaveFlag.BOLTS, 0) > 0
