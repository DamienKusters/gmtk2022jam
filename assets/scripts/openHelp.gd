extends Button

export var help_index = -1
export var help_page = "upgrades"

func _on_Help_pressed():
	Globals.openHelp(help_index, help_page)
