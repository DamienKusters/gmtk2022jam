extends CanvasItem

export var targetEvent = ""
export(Enums.SaveFlag) var defaultSaveFlag = Enums.SaveFlag.CURRENCY

func _ready():
	if targetEvent != "":
		var _a = Globals.connect(targetEvent, self, "updateVisibility");
	updateVisibility(Save.importSave(defaultSaveFlag, 0))

func updateVisibility(value: int):
	visible = value > 0
