extends Node2D

enum DiceEnum { D4, D6, D8, D10, D12, D20 };

export(DiceEnum) var kind;

var maxVal = 4;
var value = 0;
var rolling = false;

var rng = RandomNumberGenerator.new();

func _ready():
	updateDice();
	$Label.text = "";
	pass
	
func updateDice():
	if(kind == 0):
		$Sprite.texture = load("res://assets/sprites/dice/d4.png");
		$Sprite.self_modulate = Color(0.098, 0.639, 0.259);
		maxVal = 4;
	if(kind == 1):
		$Sprite.texture = load("res://assets/sprites/dice/d6.png");
		$Sprite.self_modulate = Color(0.114, 0.753, 0.827);
		maxVal = 6;
	if(kind == 2):
		$Sprite.texture = load("res://assets/sprites/dice/d8.png");
		$Sprite.self_modulate = Color(0.592, 0.231, 0.89);
		maxVal = 8;
	if(kind == 3):
		$Sprite.texture = load("res://assets/sprites/dice/d10.png");
		$Sprite.self_modulate = Color(0.89, 0.169, 0.588);
		maxVal = 10;
	if(kind == 4):
		$Sprite.texture = load("res://assets/sprites/dice/d12.png");
		$Sprite.self_modulate = Color(0.859, 0.235, 0.255);
		maxVal = 12;
	if(kind == 5):
		$Sprite.texture = load("res://assets/sprites/dice/d20.png");
		$Sprite.self_modulate = Color(0.953, 0.502, 0);
		maxVal = 20;
		
func roll():
	if(rolling):
		return;
	rolling = true;
	rng.randomize();
	$Timer.wait_time = rng.randf_range(.5,5);
	$Timer.start();
	$Sprite/AnimationPlayer.play("rotate");
	$Label.text = "";

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		roll();

func _on_Timer_timeout():
	rolling = false;
	$Sprite/AnimationPlayer.stop();
	$Sprite/AnimationPlayer.play("RESET");
	
	rng.randomize();
	value = rng.randi_range(1, maxVal);	
	$Label.text = String(value);
