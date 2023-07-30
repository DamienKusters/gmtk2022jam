class_name EnemyTier

var enemy_pool: Array = []
var special_loot_rarity: float = 0;
var rng = RandomNumberGenerator.new()
export(Enums.LootType) var special_loot = Enums.LootType.FEATHERS

func _init(_enemy_pool: Array, _special_loot_rarity: float, _special_loot = Enums.LootType.FEATHERS):
	self.enemy_pool = _enemy_pool
	self.special_loot_rarity = _special_loot_rarity
	self.special_loot = _special_loot

func getRandomEnemy():
	rng.randomize()
	return enemy_pool[rng.randi_range(0, enemy_pool.size() - 1)]

func enemyHasSpecialLoot():
	rng.randomize()
	return special_loot_rarity > rng.randf_range(0,1)
