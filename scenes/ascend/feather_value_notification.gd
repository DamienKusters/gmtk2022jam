extends Label

func _ready():
	var _a = Globals.connect("feathersUpdated", self, "updateLabel")
	updateLabel(0)

func updateLabel(_a):
	text = "Ascending now will convert\nyour remaining " + str(Globals.feathers) + " feathers\ninto " + str(Save.importSave(Enums.SaveFlag.A_FEATHER_VALUE, 1) * (10 * Globals.feathers)) + " starting bounty.\n(Feather Value Multiplier = " + str(Save.importSave(Enums.SaveFlag.A_FEATHER_VALUE, 1)) +")"
