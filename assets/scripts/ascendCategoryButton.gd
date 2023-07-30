extends Button

export var label_text = "Upgrades"
export(Texture) var texture = null

func _ready():
	$VBoxContainer/Label.text = label_text
	$VBoxContainer/TextureRect.texture = texture
