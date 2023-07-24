class_name EnemyTier

var enemy_pool: Array = []
var feather_rarity: float = 0;
var rng = RandomNumberGenerator.new()

func _init(_enemy_pool: Array, _feather_rarity: float):
	self.enemy_pool = _enemy_pool
	self.feather_rarity = _feather_rarity

func getRandomEnemy():
	rng.randomize()
	return enemy_pool[rng.randi_range(0, enemy_pool.size() - 1)]

func enemyHasFeather():
	rng.randomize();
	return feather_rarity > rng.randf_range(0,1)
