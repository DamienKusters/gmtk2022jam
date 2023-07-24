extends Node

#func importSave():
#	pass
#
#func exportSave(_value: String, _flag = Enums.SaveFlag.CURRENCY):
#	if('|' in _value):
#		push_error("Character '|' not allowed in save")
#		return
#	pass
#
##suggestion
## Saveable Node object ->
#class_name Saveable
#export(Enums.SaveFlag) var save_flag = Enums.SaveFlag.CURRENCY
#export var default_value: String = "0"
