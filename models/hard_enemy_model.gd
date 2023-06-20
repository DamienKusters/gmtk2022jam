extends EnemyModel
class_name HardEnemyModel

export var health_multiplier = 2
export var currency_multiplier = 2
export var hard_sprite: Texture

#func _init(name: String, health: int, currency: int, sprite: String = self.name, shield = null):
#	self._init(name, health, currency, sprite, shield)
#	self.name = name
#	self.health = health
#	self.currency = currency
#	self.sprite = load("res://assets/sprites/enemies/%d.png" % sprite)
#	self.shield = shield
