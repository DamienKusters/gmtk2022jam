extends Control

onready var particle = preload("res://scenes/shared/single_particle_effect_ascend.tscn");

export(String, MULTILINE) var title

export(Enums.SaveFlag) var value_flag
export(Enums.SaveFlag) var level_flag
export(int) var default_value = 0
export var help_index = -1
export var help_page = "ascend"
var value: int
var level: int

var roll_price = 1;
var upgrade_price = 2;
var rng = RandomNumberGenerator.new();

func _ready():
	$Label.text = title;
	value = Save.importSave(value_flag, default_value)
	level = Save.importSave(level_flag, 0)
	render()
	$TextureRect/Help.help_index = help_index
	$TextureRect/Help.help_page = help_page

func _on_Roll_pressed():
	var d = Globals.getDiceData(level);
	if Globals.feathers >= roll_price:
		if value == d['value']:
			return;
		rng.randomize();
		value = rng.randi_range(1,d['value']);
		Save.exportSave(value_flag, value)
		Globals.removeFeathers(roll_price);
		particles(roll_price)
		playRandomSound();
		$Tween.interpolate_property($TextureRect/Label,
			"self_modulate",
			Color("00ffffff"),
			Color("ffffffff"),
			.7,
			Tween.EASE_IN_OUT
		);
		$Tween.start();
		render()

func render():
	var d = Globals.getDiceData(level);
	$TextureRect.texture = load(d['texture']);
	
	$TextureRect/Label.text = str(value)
	
	if(level != 5):
		var change = Globals.getDiceData(level+1)['value'] - d['value'];
		upgrade_price = d['value'] - 4 + change;
	elif (level == 0):
		upgrade_price = 2;
	$Buttons/NinePatchRect2/VBoxContainer/HBoxContainer/Label.text = str(upgrade_price)
	
	$Buttons/NinePatchRect/VBoxContainer/HBoxContainer/Label.text = str(roll_price)
	
	if value == d['value']:
		$Buttons/NinePatchRect.self_modulate = Color("6fff");
		$Buttons/NinePatchRect/VBoxContainer/HBoxContainer.visible = false;
	else:
		$Buttons/NinePatchRect.self_modulate = Color("ffff");
		$Buttons/NinePatchRect/VBoxContainer/HBoxContainer.visible = true;
	
	if level == 5:
		$Buttons/NinePatchRect2.self_modulate = Color("6fff");
		$Buttons/NinePatchRect2/VBoxContainer/HBoxContainer.visible = false;
	else:
		$Buttons/NinePatchRect2.self_modulate = Color("ffff");
		$Buttons/NinePatchRect2/VBoxContainer/HBoxContainer.visible = true;

func _on_Upgrade_pressed():
	if Globals.feathers >= upgrade_price:
		if value == 20 || level == 5:
			return;
		level += 1
		Save.exportSave(level_flag, level)
		Globals.removeFeathers(upgrade_price)
		particles(upgrade_price)
		playRandomSound()
		render()

func particles(amount):
	var p = particle.instance();
	p.amount = amount;
	add_child(p);

func playRandomSound():
	rng.randomize();
	$AudioStreamPlayer.pitch_scale = rng.randf_range(0.2, 0.3);
	$AudioStreamPlayer.play();
