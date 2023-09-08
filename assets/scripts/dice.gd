extends Node2D

var rollSounds = [
	preload("res://assets/sound/dice/roll2.mp3"),
	preload("res://assets/sound/dice/roll3.mp3"),
	preload("res://assets/sound/dice/roll4.mp3"),
];

export(Enums.DiceEnum) var kind = Enums.DiceEnum.D4;

var maxVal = 4
var value = 0
var rolling = false
var active = false

var rng = RandomNumberGenerator.new();

func _ready():
	$Label.text = ""
	$Sprite.texture = null
	visible = false
	active = false
	
func updateDice(type = Enums.DiceEnum.D4):
	$Timer.stop()
	rolling = false
	active = true
	visible = true
	kind = type
	var diceData = Globals.getDiceData(kind)
	$Label.text = ""
	$Sprite.texture = load(diceData['texture'])
	$Sprite.self_modulate = diceData['color']
	maxVal = diceData['value']
	$Sprite/AnimationPlayer.play("spawn")
		
func roll():
	if(rolling || active == false):
		return
	rolling = true
	rng.randomize()
	$Timer.wait_time = rng.randf_range(Globals.minDiceRollTime,Globals.maxDiceRollTime)
	$Timer.start()
	#TODO: Tween a bit scuffed, some roll faster then others, also must keep rolling normally on reroller
	$Tween.stop_all()
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color("2effffff"), .15, Tween.EASE_OUT);
	$Tween.start()
	if $Sprite/AnimationPlayer.is_playing() == false:
		$Sprite/AnimationPlayer.play("rotate")
	$Label.text = "";

func playRandomRollSound():
	if(active == false):
		return
	rng.randomize()
	var stream = rollSounds[rng.randi_range(0, rollSounds.size()-1)];
	$AudioStreamPlayer.stream = stream
	$AudioStreamPlayer.play()

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if(active == false):
		return
	if (event is InputEventMouseButton && event.pressed):
		if(rolling):
			return
		roll()
		playRandomRollSound()
		Input.set_default_cursor_shape(Input.CURSOR_ARROW);
		var d = Save.importSave(Enums.SaveFlag.U_QUICKROLL, 0)
		if d > 0:
			for i in d:
				Globals.emit_signal("rollRandomDice")

func _on_Timer_timeout():
	if(rolling && active == false):
		return
	rolling = false
	rng.randomize();
	if maxVal == 100:
		value = rng.randi_range(1, 10) * 10
	else:
		value = rng.randi_range(1, maxVal)
		
	$Label.text = String(value)
	$Label2.text = String(value)
	$Label2/AnimationPlayer.play("RESET")
	$Label2/AnimationPlayer.play("hit")
	
	Globals.emit_signal("damageEnemy", value, self)
	
	var s_reroll = Save.importSave(Enums.SaveFlag.U_SUPER_REROLL, 0)
	var reroll = Save.importSave(Enums.SaveFlag.U_REROLL, 0)
	if s_reroll > 0:
		if(value <= int((s_reroll + 2)) * 10):
			roll()
			return
	elif reroll > 0:
		if(value <= reroll):
			roll()
			return
	
	$Tween.interpolate_property($Sprite, "modulate", $Sprite.modulate, Color(1,1,1,1),.5,Tween.TRANS_BACK)
	$Tween.interpolate_property($Sprite, "rotation_degrees",0, 360.0,1.5,Tween.TRANS_BACK,Tween.EASE_OUT)
	$Tween.start()
	
	$Sprite/AnimationPlayer.play("RESET")
	$Sprite/AnimationPlayer.stop()

func _on_Area2D_mouse_entered():
	if(active == false):
		return
	if rolling == false:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_Area2D_mouse_exited():
	if(active == false):
		return
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func exportSave():
	return str(kind);
