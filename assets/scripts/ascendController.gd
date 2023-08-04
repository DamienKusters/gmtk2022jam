extends Control

func _ready():
	$ui/fader/angelic.visible = false
	$ui/fader/shadow.visible = false

func ascend():
	Save.saveGame()
	Globals.ascendReset();
	var _a = get_tree().change_scene("res://scenes/main.tscn");

func showMenu():
	$ui/MenuNavigator.play("show_menu")
	$ui/fader/angelic.visible = false
	$ui/fader/shadow.visible = false

func _on_upgrades_pressed(id: int):
	$ui/MenuNavigator.play("hide_menu")
	
	match(id):
		0:
			$ui/fader/angelic.visible = true
		1:
			$ui/fader/shadow.visible = true
