extends Control

enum Ascention {DPS,REROLLER};#TODO: Use resource

signal valueUpdated;

onready var particle = preload("res://scenes/shared/single_particle_effect_ascend.tscn");
onready var zero_dice = preload("res://assets/sprites/dice/d0.png");

var resource = preload("res://resources/ascend_resource.gd").AscendResource.new();

export(Ascention) var ascention;
export var value = 1;
export var prepend = "x" setget setPrepend, getPrepend;
export var level = 0;

var reroll_price = 1;
var upgrade_price = 2;

func setPrepend(v):
	prepend = v;
	$List/PrependLabel.text = prepend;
	
func getPrepend():
	return prepend;

var rng = RandomNumberGenerator.new();

func _ready():
	resource.connect("reload",self,"reload");
	if(ascention == Ascention.DPS):
		value = Globals.ascention_dps_multiplier_value;
		level = Globals.ascention_dps_multiplier_level;
	elif(ascention == Ascention.REROLLER):
		value = Globals.ascention_reroller_value;
		level = Globals.ascention_reroller_level;
	render();

func reload():
	level = resource.level;
	value = resource.value;
	render();
	
	#Temp
#	if(ascention == Ascention.DPS):
#		Globals.ascention_dps_multiplier_value = value;
#	elif(ascention == Ascention.REROLLER):
#		Globals.ascention_reroller_value = value;

func render():
	var d = Globals.getDiceData(level);
	$List/TextureButton.texture = load(d['texture']);
	$List/TextureButton/Label.text = "";
	$List/TextureButton/Label.text = str(value);
	if value == 0 && level == 0:
		$List/TextureButton.texture = zero_dice;
	
	if(level != 5):
		var change = Globals.getDiceData(level+1)['value'] - d['value'];
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
	
	$List/Control/TextureButton2.disabled = level == 5;
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
		var d = Globals.getDiceData(level);
		rng.randomize();
		value = rng.randi_range(1,d['value']);
		Globals.removeFeathers(price);
		particles(price);
		playRandomSound();
		$List/TextureButton/Label/Tween.interpolate_property($List/TextureButton/Label,
			"self_modulate",
			Color("00ffffff"),
			Color("ffffffff"),
			.7,
			Tween.EASE_OUT
		);
		$List/TextureButton/Label/Tween.start();
		render();
		emit_signal("valueUpdated", value);
		if(ascention == Ascention.DPS):
			Globals.ascention_dps_multiplier_value = value;
		elif(ascention == Ascention.REROLLER):
			Globals.ascention_reroller_value = value;

func _on_BtnUpgrade_pressed():
	if Globals.feathers >= upgrade_price:
		if value == 20 || level == 5:
			return;
		level += 1;
		Globals.removeFeathers(upgrade_price);
		particles(upgrade_price);
		playRandomSound();
		render();
		if(ascention == Ascention.DPS):
			Globals.ascention_dps_multiplier_level = level;
		elif(ascention == Ascention.REROLLER):
			Globals.ascention_reroller_level = level;

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

func playRandomSound():
	rng.randomize();
	$AudioStreamPlayer.pitch_scale = rng.randf_range(0.2, 0.3);
	$AudioStreamPlayer.play();
