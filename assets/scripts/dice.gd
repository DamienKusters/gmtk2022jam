extends Node2D

var rollSounds = [
	preload("res://assets/sound/dice/roll2.mp3"),
	preload("res://assets/sound/dice/roll3.mp3"),
	preload("res://assets/sound/dice/roll4.mp3"),
];

export(Enums.DiceEnum) var kind;
export(float) var minRollingSpeed = .5;

var maxVal = 4;
var value = 0;
var rolling = false;

var rng = RandomNumberGenerator.new();

func _ready():
	updateDice();
	$Label.text = "";
	
func updateDice():
	var diceData = Globals.getDiceData(kind);
	$Sprite.texture = load(diceData['texture']);
	$Sprite.self_modulate = diceData['color'];
	maxVal = diceData['value'];
		
func roll():
	if(rolling):
		return;
	rolling = true;
	$Tween.stop_all();
	rng.randomize();
	$Timer.wait_time = rng.randf_range(minRollingSpeed,Globals.maxDiceRollTime);
	$Timer.start();
	$Sprite/AnimationPlayer.play("RESET");
	$Sprite/AnimationPlayer.play("rotate");
	$Label.text = "";

func playRandomRollSound():
	rng.randomize();
	var stream = rollSounds[rng.randi_range(0, rollSounds.size()-1)];
	$AudioStreamPlayer.stream = stream;
	$AudioStreamPlayer.play();

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		if(rolling):
			return;
		roll();
		playRandomRollSound();
		Input.set_default_cursor_shape(Input.CURSOR_ARROW);

func _on_Timer_timeout():
	rolling = false;
	$Sprite/AnimationPlayer.play("RESET");
	$Sprite/AnimationPlayer.stop();
	$Tween.interpolate_property($Sprite, "modulate",$Sprite.modulate, Color(1,1,1,1),.5,Tween.TRANS_BACK);
	$Tween.interpolate_property($Sprite, "rotation_degrees",$Sprite.rotation_degrees, 360.0,1.5,Tween.TRANS_BACK,Tween.EASE_OUT);
	$Tween.start();
	
	rng.randomize();
	value = rng.randi_range(1, maxVal);
	$Label.text = String(value);
	$Label2.text = String(value);
	$Label2/AnimationPlayer.play("RESET");
	$Label2/AnimationPlayer.play("hit");
	
	Globals.emit_signal("damageEnemy", value, self);

func _on_Area2D_mouse_entered():
	if rolling == false:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND);

func _on_Area2D_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW);

func exportSave():
	return str(kind);
