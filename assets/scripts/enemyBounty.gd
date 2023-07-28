tool
extends TextureRect

export(Texture) var itemTexture = load("res://assets/sprites/icons/angel_feather.png") setget setItemTexture
export(Color) var shadeColor = Color("ECE6B0") setget setShadeColor

func setItemTexture(value):
	itemTexture = value
	texture = value
	
func setShadeColor(value):
	shadeColor = value
	$TextureRect.self_modulate = value
