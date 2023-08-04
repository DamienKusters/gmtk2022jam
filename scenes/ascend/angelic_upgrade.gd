extends Control

export(String, MULTILINE) var title

export(Enums.SaveFlag) var value_flag
export(Enums.SaveFlag) var level_flag
export(int) var default_value = 0
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

func _on_Roll_pressed():
	var d = Globals.getDiceData(level);
	if Globals.feathers >= roll_price:
		if value == d['value']:
			return;
		rng.randomize();
		value = rng.randi_range(1,d['value']);
		Globals.removeFeathers(roll_price);
#		particles(price);
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
		Save.exportSave(value_flag, value)
	

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
		Globals.removeFeathers(upgrade_price)
		playRandomSound()
		render()
		Save.exportSave(level_flag, level)

func playRandomSound():
	rng.randomize();
	$AudioStreamPlayer.pitch_scale = rng.randf_range(0.2, 0.3);
	$AudioStreamPlayer.play();
