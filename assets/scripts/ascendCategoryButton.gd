extends Button

onready var label = load("res://scenes/styledLabel.tscn")

export var label_text = "Upgrades"
export(Texture) var texture = null

export var targetEvent = "currencyUpdated"
export(Enums.SaveFlag) var defaultSaveFlag = Enums.SaveFlag.CURRENCY
export(Color) var color = Color('ece6b0')
export(Texture) var lootIcon = load("res://assets/sprites/icons/angel_feather.png")

func _ready():
	var l = label.instance()
	l.targetEvent = targetEvent
	l.defaultSaveFlag = defaultSaveFlag
	l.self_modulate = color
	$VBoxContainer/feathers.add_child(l)
	$VBoxContainer/feathers/TextureRect.texture = lootIcon
	
	$VBoxContainer/Label.text = label_text
	$VBoxContainer/TextureRect.texture = texture
