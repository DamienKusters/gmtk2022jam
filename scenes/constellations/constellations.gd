extends Control

var unlocked_dragons: Array
var all_dragons_unlocked := false

var dragon_save_flag_mapping = [
	Enums.SaveFlag.DRG_1,
	Enums.SaveFlag.DRG_2,
	Enums.SaveFlag.DRG_3,
	Enums.SaveFlag.DRG_4,
	Enums.SaveFlag.DRG_5,
	Enums.SaveFlag.DRG_6,
	Enums.SaveFlag.DRG_7,
	Enums.SaveFlag.DRG_8,
	Enums.SaveFlag.DRG_9,
	Enums.SaveFlag.DRG_10,
	Enums.SaveFlag.DRG_11,
	Enums.SaveFlag.DRG_12,
	Enums.SaveFlag.DRG_13,
	Enums.SaveFlag.DRG_14,
	Enums.SaveFlag.DRG_15,
	Enums.SaveFlag.DRG_16,
	Enums.SaveFlag.DRG_17,
	Enums.SaveFlag.DRG_18,
	Enums.SaveFlag.DRG_19,
	Enums.SaveFlag.DRG_20,
]

func _ready():
	$Label.visible = false
	for flag in dragon_save_flag_mapping:
		unlocked_dragons.append(true if Save.importSave(flag, 0) == 1 else false)
	for u in unlocked_dragons:
		if u == false:
			return
	all_dragons_unlocked = true

func _on_AnimationPlayer_animation_finished(_anim_name):
	pass

# Called by AnimationPlayer
func generate_dragon_index():
	randomize()
	var random_index: int = 19
	if all_dragons_unlocked == false:
		random_index = int(round(rand_range(0,19)))
		while(unlocked_dragons[random_index] == true):
			randomize()
			random_index = int(round(rand_range(0,19)))
		print(random_index)
	Save.exportSave(dragon_save_flag_mapping[random_index], 1, true)
	$Label.text = str(random_index + 1)
	$Label.visible = true
	_animate_label_blink()

func _animate_label_blink():
	$"%LabelTween".interpolate_property($Label, "modulate", Color.transparent, Color.white, .3)
	$"%LabelTween".interpolate_property($Label, "modulate", Color.white, Color.transparent, .7)
	$"%LabelTween".start()
