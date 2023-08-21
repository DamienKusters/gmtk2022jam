extends Label

export var targetEvent = "currencyUpdated"
export(Enums.SaveFlag) var defaultSaveFlag = Enums.SaveFlag.CURRENCY
export var useSafeFlag = false

func _ready():
	var _a = Globals.connect(targetEvent, self, "updateLabel");
	text = str(Save.importSave(defaultSaveFlag, 0))

func updateLabel(value: int):
	if useSafeFlag:
		text = str(Save.importSave(defaultSaveFlag, text, false));
	else:
		text = str(value);
