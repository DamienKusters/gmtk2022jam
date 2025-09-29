extends Sprite

var target = Vector2(561,315)

var maxXOffset = 130
var maxYOffset = 70

var SPEED = 1.7

func _ready():
	var delay = rand_range(0.0, SPEED)  # random offset in seconds
	yield(get_tree().create_timer(delay), "timeout")
	$Tween.connect("tween_completed", self, "repeat_tween")
	repeat_tween(null, null)

func repeat_tween(val1,val2):
	if val1 != null: # Not manual, so use particle
		$"../CPUParticles2D".global_position = $Bullet.global_position 
		$"../CPUParticles2D".restart()
	$Tween.stop_all()
	rotation_degrees = 0.0
	$Bullet.global_position = self.global_position
	$Bullet.scale = Vector2(0.6,0.6)
	var t = Vector2(rand_range(target.x - maxXOffset, target.x + maxXOffset), rand_range(target.y - maxYOffset, target.y + maxYOffset))
	$Tween.interpolate_property(self, "rotation_degrees",self.rotation_degrees, 360.0,SPEED,Tween.TRANS_BACK,Tween.EASE_OUT_IN)
	$Tween.interpolate_property($Bullet, "global_position",$Bullet.global_position, t,SPEED,Tween.TRANS_BACK,Tween.EASE_IN)
	$Tween.interpolate_property($Bullet, "scale",$Bullet.scale, Vector2.ZERO,SPEED,Tween.TRANS_BACK,Tween.EASE_IN)
	$Tween.start()
	

