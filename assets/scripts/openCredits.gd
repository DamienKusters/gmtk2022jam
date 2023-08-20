extends Control

func showOptions():
	$"../Options".visible = true

func showCredits():
	Globals.openHelp(0, "credits")

func showHelp():
	Globals.openHelp(0, "game")
