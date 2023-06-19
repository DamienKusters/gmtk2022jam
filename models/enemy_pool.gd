class_name EnemyPool

var enemy_tiers: Array = [
	EnemyTier.new(),
]

func getRandomEnemyFromPool():
	return enemy_tiers[0].getRandomEnemy()
