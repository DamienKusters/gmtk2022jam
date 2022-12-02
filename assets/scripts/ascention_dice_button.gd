extends Control

enum Ascention {DPS,REROLLER};#TODO: Use resource
enum Dice {D0,D4,D6,D8,D10,D12,D20};

signal valueUpdated;

onready var particle = preload("res://scenes/shared/single_particle_effect_ascend.tscn");

var resource = preload("res://resources/ascend_resource.gd").AscendResource.new();

export(Ascention) var ascention;
export var value = 1;
export var prepend = "x" setget setPrepend, getPrepend;
export(Dice) var level;

var reroll_price = 1;
var upgrade_price = 2;

func setPrepend(value):
	prepend = value;
	$List/PrependLabel.text = prepend;
	
func getPrepend():
	return prepend;

var rng = RandomNumberGenerator.new();

func _ready():
	resource.connect("reload",self,"reload");
	if(ascention == Ascention.DPS):
		value = Globals.ascention_dps_multiplier;
	elif(ascention == Ascention.REROLLER):
		value = Globals.ascention_reroller;
	render();

func reload():
	level = resource.level;
	value = resource.value;
	render();
	
	#Temp
	if(ascention == Ascention.DPS):
		Globals.ascention_dps_multiplier = value;
	elif(ascention == Ascention.REROLLER):
		Globals.ascention_reroller = value;

#Sorry
func getDiceData(lvl):
	match lvl:
		Dice.D0:
			return {
				"value": 0,
				"texture": "res://assets/sprites/dice/d0.png",
			};
		Dice.D4:
			return {
				"value": 4,
				"texture": "res://assets/sprites/dice/d4.png",
			};
		Dice.D6:
			return {
				"value": 6,
				"texture": "res://assets/sprites/dice/d6.png",
			};
		Dice.D8:
			return {
				"value": 8,
				"texture": "res://assets/sprites/dice/d8.png",
			};
		Dice.D10:
			return {
				"value": 10,
				"texture": "res://assets/sprites/dice/d10.png",
			};
		Dice.D12:
			return {
				"value": 12,
				"texture": "res://assets/sprites/dice/d12.png",
			};
		Dice.D20:
			return {
				"value": 20,
				"texture": "res://assets/sprites/dice/d20.png",
			};

func render():
	var d = getDiceData(level);
	$List/TextureButton.texture = load(d['texture']);
	$List/TextureButton/Label.text = "";
	$List/TextureButton/Label.text = str(value);
	
	if(level != 6 && level != 0):
		var change = getDiceData(level+1)['value'] - d['value'];
		upgrade_price = d['value'] - 4 + change;
		$List/Control/TextureButton2/HBoxContainer/Label.text = "-" + str(upgrade_price);
	elif (level == 0):
		upgrade_price = 2;
		$List/Control/TextureButton2/HBoxContainer/Label.text = "-" + str(upgrade_price);
	
	$List/Control/TextureButton.disabled = value != 0 && value == d['value'];
	if $List/Control/TextureButton.disabled:
		$List/Control/TextureButton.self_modulate = Color("6fff");
		$List/Control/TextureButton/HBoxContainer.visible = false;
	else:
		$List/Control/TextureButton.self_modulate = Color("ffff");
		$List/Control/TextureButton/HBoxContainer.visible = true;
	
	$List/Control/TextureButton2.disabled = level == 6;
	if $List/Control/TextureButton2.disabled:
		$List/Control/TextureButton2.self_modulate = Color("6fff");
		$List/Control/TextureButton2/HBoxContainer.visible = false;
	else:
		$List/Control/TextureButton2.self_modulate = Color("ffff");
		$List/Control/TextureButton2/HBoxContainer.visible = true;

func _on_BtnReroll_pressed():
	var price = 1;
	if Globals.feathers >= price:
		if value == 20:
			return;
		if level == Dice.D0:
			level = Dice.D4;
		var d = getDiceData(level);
		rng.randomize();
		value = rng.randi_range(1,d['value']);
		Globals.removeFeathers(price);
		particles(price);
		render();
		emit_signal("valueUpdated", value);
		if(ascention == Ascention.DPS):
			Globals.ascention_dps_multiplier = value;
		elif(ascention == Ascention.REROLLER):
			Globals.ascention_reroller = value;

func _on_BtnUpgrade_pressed():
	if Globals.feathers >= upgrade_price:
		if value == 20:
			return;
		if level == Dice.D0:
				level = Dice.D4;
		match level:
			Dice.D4:
				level = Dice.D6;
			Dice.D6:
				level = Dice.D8;
			Dice.D8:
				level = Dice.D10;
			Dice.D10:
				level = Dice.D12;
			Dice.D12:
				level = Dice.D20;
			Dice.D20:
				return;
		Globals.removeFeathers(upgrade_price);
		particles(upgrade_price);
		render();

func particles(amount):
	var p = particle.instance();
	p.amount = amount;
	add_child(p);

func _on_Control_mouse_entered():
	$List/TextureButton/Tween.stop_all();
	$List/TextureButton/Tween.interpolate_property($List/TextureButton,
		"rect_scale",
		$List/TextureButton.rect_scale,
		Vector2(1.2,1.2),
		.2,
		Tween.EASE_IN_OUT
		);
	$List/TextureButton/Tween.start();


func _on_Control_mouse_exited():
	$List/TextureButton/Tween.stop_all();
	$List/TextureButton/Tween.interpolate_property($List/TextureButton,
		"rect_scale",
		$List/TextureButton.rect_scale,
		Vector2(1,1),
		.2,
		Tween.EASE_IN_OUT
		);
	$List/TextureButton/Tween.start();
