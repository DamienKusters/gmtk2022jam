class_name EnemyTier

#TODO: feather rarity percentage of this tier

var enemy_pool: Array = []
var rng = RandomNumberGenerator.new()

func _init(enemy_pool: Array):
	self.enemy_pool = enemy_pool

func getRandomEnemy():
	rng.randomize()
	return enemy_pool[rng.randi_range(0, enemy_pool.size() - 1)]
