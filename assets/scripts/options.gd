extends Node

func _ready():
	_on_MusicSlider_value_changed(1);
	_on_SoundSlider_value_changed(3);
	
func exportSave():
	$HBoxContainer/SaveTextEdit.text = Globals.exportSave();

func importSave():
	Globals.importSave($HBoxContainer/SaveTextEdit.text.strip_edges(true,true));

func _on_MusicSlider_value_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(1, true);
	else:
		AudioServer.set_bus_mute(1, false);
		AudioServer.set_bus_volume_db(1, value)
	pass # Replace with function body.


func _on_SoundSlider_value_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(2, true);
	else:
		AudioServer.set_bus_mute(2, false);
		AudioServer.set_bus_volume_db(2, value)
	pass # Replace with function body.
