extends VBoxContainer

#spaghett

func _ready():
	var _a = Globals.connect("feathersUpdated", self, 'render')
	render(0)
	renderVisibility()

func _on_ConvertButton_button_clicked():
	var s_feathers = Save.importSave(Enums.SaveFlag.DARK_FEATHERS, 0)
	var added_multiplier = floor(s_feathers / 10)
	var feather_cost = added_multiplier * 10
	
	Globals.dFeathers -= feather_cost
	var s_multiplier = Save.importSave(Enums.SaveFlag.AS_MULTIPLIER_VALUE, 0)
	Save.exportSave(Enums.SaveFlag.AS_MULTIPLIER_VALUE, s_multiplier + added_multiplier)
	render(0)

func render(_a):
	$HBoxContainer/Label.text = "Current multiplier: x" + str(Save.importSave(Enums.SaveFlag.A_MULTIPLIER_VALUE, 1) + Save.importSave(Enums.SaveFlag.AS_MULTIPLIER_VALUE, 0))

func renderVisibility():
	visible = (Save.importSave(Enums.SaveFlag.AS_ENHANCE_DICE, 0) > 0 &&
		Save.importSave(Enums.SaveFlag.AS_QUICKROLL, 0) > 0 &&
		Save.importSave(Enums.SaveFlag.AS_OVERDRIVE, 0) > 0 &&
		Save.importSave(Enums.SaveFlag.AS_SUPER_REROLL, 0) > 0 &&
		Save.importSave(Enums.SaveFlag.AS_DELETE_DICE, 0) > 0 &&
		Save.importSave(Enums.SaveFlag.AS_HEXAGRAM, 0) > 0)
