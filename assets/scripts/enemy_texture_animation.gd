extends TextureRect

export var damage_intensity_min = 7
export var damage_intensity_max = 0
var rng = RandomNumberGenerator.new()
var directions = [
	Vector2.UP,
	Vector2.DOWN,
	Vector2.RIGHT,
	Vector2.LEFT,
	Vector2(1,1),
	Vector2(-1,-1),
	Vector2(1,-1),
	Vector2(-1,1),
]

func _ready():
	damage_intensity_max = (Save.importSave(Enums.SaveFlag.A_MULTIPLIER_VALUE, 1) + Save.importSave(Enums.SaveFlag.AS_MULTIPLIER_VALUE, 0))

func addFade():
	$Tween.interpolate_property(self, 'self_modulate', Color("7e7e7e"), Color("ffffff"), .15, Tween.EASE_OUT)

func addRandomDirection():
	$Tween.interpolate_property(self, 'rect_position', _getRandomDir() * rng.randf_range(damage_intensity_min, damage_intensity_max), Vector2.ZERO, .15, Tween.EASE_OUT)	

func addRandomRotation():
	$Tween.interpolate_property(self, 'rect_rotation', _getRandomRot(), 0, .15, Tween.EASE_OUT)	

func startAnimation():
	$Tween.start()

func _getRandomDir():
	return directions[rng.randi_range(0, directions.size()-1)]

func _getRandomRot():
	return rng.randf_range(-3, 3)
	
