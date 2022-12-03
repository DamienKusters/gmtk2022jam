extends Node

func exportSave():
	$HBoxContainer/SaveTextEdit.text = Globals.exportSave();

func importSave():
	Globals.importSave($HBoxContainer/SaveTextEdit.text.strip_edges(true,true));
