extends Timer

export(bool) var for_use_in_ascention = false # dumb
export(NodePath) var animation_player
export var animation_player_blink: String = "blink"
export(NodePath) var smoke_particles
export(NodePath) var rubble_particles
export(NodePath) var ascend_animation_player

onready var animation_player_node = get_node(animation_player)
onready var smoke_particles_node = get_node(smoke_particles)
onready var rubble_particles_node = get_node(rubble_particles)
onready var ascend_animation_player_node = get_node(ascend_animation_player)

var crashed = false
var first_run = true

func _ready():
	get_parent().connect("ready", self, "_on_DestroyerVisualIndicator_timeout")
	if for_use_in_ascention:
		$"../../../..".connect("spawn_screen_finished", self, "check_crash")

func _on_DestroyerVisualIndicator_timeout():
	if crashed:
		return
	
	var remaining = Globals.get_destroyer_time_remaining_epoch() - floor(Time.get_unix_time_from_system())
	
	if animation_player_node.current_animation != animation_player_blink && remaining <= 600: # 10 minutes remaining
		animation_player_node.play(animation_player_blink)
	smoke_particles_node.emitting = remaining <= 300 # 5 minutes remaining
	rubble_particles_node.emitting = remaining <= 60 # 1 minute remaining
	
	if first_run == false:
		check_crash()
	first_run = false
	
	
func check_crash():
	var remaining = Globals.get_destroyer_time_remaining_epoch() - floor(Time.get_unix_time_from_system())
	if for_use_in_ascention && remaining <= 0:
		ascend_animation_player_node.stop()
		$"../AnimationPlayer".play("crash")
		$"../../../../ui".visible = false
		crashed = true
