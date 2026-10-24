extends AnimationPlayer

func _on_AnimSpawn_animation_finished(anim_name):
	if (anim_name == "spawn"):
		play("hover")
