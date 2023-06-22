class_name EnemyPool

var rng = RandomNumberGenerator.new()

export var enemy_tiers: Array = []

#TODO: special enemies

func getRandomEnemyFromPool():
	rng.randomize()
	return enemy_tiers[rng.randi_range(0, enemy_tiers.size() - 1)].getRandomEnemy()
