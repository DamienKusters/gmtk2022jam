extends Control

enum Ascention {DPS,REROLLER};#TODO: Use resource
enum Dice {D0,D4,D6,D8,D10,D12,D20};

signal valueUpdated;

onready var g = $"/root/Globals";

export(Ascention) var ascention;
export var value = 1;
export var prepend = "x" setget setPrepend, getPrepend;
export(Dice) var level;

func setPrepend(value):
	prepend = value;
	$List/PrependLabel.text = prepend;
	
func getPrepend():
	return prepend;

var rng = RandomNumberGenerator.new();

func _ready():
	if(ascention == Ascention.DPS):
		value = g.ascention_dps_multiplier;
	elif(ascention == Ascention.REROLLER):
		value = g.ascention_reroller;
	render();

#Sorry
func getDiceData():
	match level:
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
	var d = getDiceData();
	$List/TextureButton.texture = load(d['texture']);
	$List/TextureButton/Label.text = "";
	$List/TextureButton/Label.text = str(value);


func _on_BtnReroll_pressed():
	var price = 1;
	if g.feathers >= price:
		if value == 20:
			return;
		if level == Dice.D0:
			level = Dice.D4;
		var d = getDiceData();
		rng.randomize();
		value = rng.randi_range(1,d['value']);
		g.removeFeathers(price);
		particles(price);
		render();
		emit_signal("valueUpdated", value);
		if(ascention == Ascention.DPS):
			g.ascention_dps_multiplier = value;
		elif(ascention == Ascention.REROLLER):
			g.ascention_reroller = value;

func _on_BtnUpgrade_pressed():
	var price = 2;
	if g.feathers >= price:
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
		g.removeFeathers(price);
		particles(price);
		render();

func particles(amount):
	$CPUParticles2D.amount = amount;
	$CPUParticles2D.restart();

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
