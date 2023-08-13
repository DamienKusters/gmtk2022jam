extends AudioStreamPlayer

export var minPitch = .8
export var maxPitch = 1.6

var rng = RandomNumberGenerator.new()

func playRandomPitch():
	rng.randomize()
	pitch_scale = rng.randf_range(minPitch, maxPitch)
	play()
