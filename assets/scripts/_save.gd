extends Node

signal import_save

const save_file_location = "user://test.save"
var save = {}

func importSave(_flag, _default_value):
	if save.has(_flag):
		return save[_flag]
	else:
		return _default_value

func exportSave(_flag, _value: int):
	var v = int(_value)
	save[_flag] = v
	
	saveGame()#debug

func saveGame():
	var _save = ""
	for f in Enums.SaveFlag.values():#todo local custom order?
		if save.has(f):
			_save += str(save[f]) + "|"
		else:
			_save += "|"
	
	#TODO: save file use field identifier so it can be restored no matter order of enum
	
	var file = File.new()
	file.open(save_file_location, File.WRITE)
	file.store_string(_save)
	file.close()
	pass
	
func loadGame():
	var file = File.new()
	if file.file_exists(save_file_location) == false:
		file.close()
		return
	file.open(save_file_location, File.READ)
	var content = file.get_as_text()
	file.close()
	
	var s = content.split("|")
	
	save = {}
	var x = 0
	for i in s:
		if i != "":
			save[x] = int(i)
		x += 1
	pass

func _init():
	loadGame()
