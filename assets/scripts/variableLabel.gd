extends Label

export var targetEvent = "currencyUpdated"
export(Enums.SaveFlag) var defaultSaveFlag = Enums.SaveFlag.CURRENCY

func _ready():
	Globals.connect(targetEvent, self, "updateLabel");
	text = str(Save.importSave(defaultSaveFlag, 0))

func updateLabel(value: int):
	text = str(value);
