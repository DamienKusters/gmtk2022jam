class_name EnemyModel

export var name = ""
export var health = 0
export var currency = 0
export var sprite: Texture
export var special_loot = {} #TODO: special kind of loot
export (Enums.DiceEnum) var shield = Enums.DiceEnum.D4

func _init(name: String, health: int, currency: int, sprite: String = name, shield = null):
	self.name = name
	self.health = health
	self.currency = currency
	self.sprite = load("res://assets/sprites/enemies/%s.png" % [sprite])
	self.shield = shield
