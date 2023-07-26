extends Node

func _on_MusicSlider_value_changed(value):
	Globals.options_music = value;
	if value == 0:
		AudioServer.set_bus_mute(1, true);
	else:
		AudioServer.set_bus_mute(1, false);
		AudioServer.set_bus_volume_db(1, value)

func _on_SoundSlider_value_changed(value):
	Globals.options_sound = value;
	if value == 0:
		AudioServer.set_bus_mute(2, true);
	else:
		AudioServer.set_bus_mute(2, false);
		AudioServer.set_bus_volume_db(2, value)

func _on_MusicSlider_tree_entered():
	_on_MusicSlider_value_changed(Globals.options_music);
	$HBoxContainer/HBoxContainer/MusicSlider.value = Globals.options_music;

func _on_SoundSlider_tree_entered():
	_on_SoundSlider_value_changed(Globals.options_sound);
	$HBoxContainer/HBoxContainer2/SoundSlider.value = Globals.options_sound

func _on_Save_button_clicked():
	var saved = Save.saveGame();
	if saved == true:
		$"HBoxContainer/SaveButtons/Reset Info".visible = false;
		$HBoxContainer/SaveButtons/HBoxContainer/Save.button_text = "Game Saved!"
	
func _on_ResetSave_button_clicked():
	var file = File.new()
	if file.file_exists(Save.save_file_location) == true:
		file.open(Save.save_file_location, File.WRITE)
		file.store_string("")
		file.close()
		$"HBoxContainer/SaveButtons/Reset Info".visible = true;
		resetSaveButtonText();

func resetSaveButtonText():
	$HBoxContainer/SaveButtons/HBoxContainer/Save.button_text = "Save Game"
