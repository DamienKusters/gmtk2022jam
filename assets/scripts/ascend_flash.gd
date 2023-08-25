extends ColorRect

func ascend():
	$AnimationPlayer.play("flash")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'flash':
		var _e = get_tree().change_scene("res://scenes/ascend/ascend.tscn");
