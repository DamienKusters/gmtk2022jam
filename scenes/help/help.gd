extends Control

export var help_page = 'upgrades'
var help_button = preload("res://scenes/help/help_button.tscn")

onready var help_data = Database.help[help_page]

func _ready():
	render()
	var _a = Globals.connect("openHelp", self, "loadPage")

func render():
	for c in $popup/Control/ScrollContainer/VBoxContainer.get_children():
		c.queue_free()
	var index = 0
	_addPadder()
	for h in help_data:
		addButton(h, index)
		index += 1
	_addPadder()

func addButton(data, index):
	var i = help_button.instance()
	i.text = data['name']
	if data.has('icon'):
		i.icon = data['icon']
	else:
		i.icon = null
	i.connect("pressed", self, "loadPage", [index, help_page])
	$popup/Control/ScrollContainer/VBoxContainer.add_child(i)

func loadPage(index, page = help_page):
	if page != help_page:
		help_page = page
		help_data = Database.help[page]
		render()
	var data = help_data[index]
	$popup/Control/Control/Label.text = data['description']
	$popup/Control/Control/HBoxContainer/Label.text = data['name']
	if data.has('icon'):
		$popup/Control/Control/HBoxContainer/TextureRect.texture = data['icon']
	else:
		$popup/Control/Control/HBoxContainer/TextureRect.texture = null
	$popup/Control/Control/TextureRect.texture = null
	if data.has('contextImage'):
		$popup/Control/Control/TextureRect.texture = data['contextImage']
	else:
		$popup/Control/Control/TextureRect.texture = null
	visible = true

func _addPadder():
	var x = Control.new()
	x.rect_min_size = Vector2(0,13)
	$popup/Control/ScrollContainer/VBoxContainer.add_child(x)


func _on_Button_pressed():
	visible = false
