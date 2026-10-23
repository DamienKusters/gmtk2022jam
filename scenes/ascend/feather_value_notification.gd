extends Control

var lblFeather = Enums.SaveFlag.A_FEATHER_VALUE
var lblMultiplier = Enums.SaveFlag.A_MULTIPLIER_VALUE
var lblReroller = Enums.SaveFlag.A_REROLL_VALUE

func _ready():
	visible = false

func show():
	updateLabel()
	visible = true

func updateLabel():
	$Label.text = "Ascending now will;\n" \
		+ "- Multiply all damage by x" + str(Save.importSave(lblMultiplier, 1) + Save.importSave(Enums.SaveFlag.AS_MULTIPLIER_VALUE, 0), "\n") \
		+ "- Convert feathers into " + str(Save.importSave(lblFeather, 1) * (50 * Globals.feathers)) + " starting bounty\n" \
		+ "- Set the Re-roller level to " + str(Save.importSave(lblReroller, 0), "\n") \
		+ "\nClick 'Ascend' once more to confirm"
