extends Node

const save_file_location = "user://dnde.save"
var save = {}

func importSave(_flag, _default_value, to_int = true):
	var ret
	if save.has(_flag):
		ret = save[_flag]
	else:
		ret = _default_value
	if to_int:
		return int(ret)
	else:
		return str(ret)

func exportSave(_flag, _value, autosave = false):
	var v = str(_value)
	save[_flag] = v
	
	if autosave:
		saveGame()

func resetSave():
	save = {}

func saveGame():
	var _save = ""
	for f in Enums.SaveFlag.values():#todo local custom order?
		if save.has(f):
			_save += str(save[f]) + "|"
		else:
			_save += "|"
	
	#TODO: save file use set order so it can be restored no matter order of enum
	
	var file = File.new()
	file.open(save_file_location, File.WRITE)
	var raw_save = _save
#	raw_save = Marshalls.utf8_to_base64(_save)
	file.store_string(raw_save)
	file.close()
	return true
	
func loadGame():
	var file = File.new()
	
	if file.file_exists(save_file_location) == false:
		file.close()
		return
	file.open(save_file_location, File.READ)
	var raw_save = file.get_as_text()
	file.close()
	
#	raw_save = Marshalls.base64_to_utf8(raw_save);
	var s = raw_save.split("|")
	
	save = {}
	var x = 0
	for i in s:
		if i != "":
			save[x] = str(i)
		x += 1
	pass

func deleteGame():
	var file = File.new()
	if file.file_exists(save_file_location) == true:
		file.open(Save.save_file_location, File.WRITE)
		file.store_string("")
		file.close()
		return true
	return false

func _init():
	loadGame()
