class_name EnemyModel

export var name = ""
export var health = 0
export var currency = 0
export var sprite: Texture
export var special_loot = {} #TODO: special kind of loot
export (Enums.DiceEnum) var shield = Enums.DiceEnum.D4

func _init(_name: String, _health: int, _currency: int, _sprite: String = "", _shield = null):
	self.name = _name
	self.health = _health
	self.currency = _currency
	if _sprite == "":
		_sprite = _name
	self.sprite = load("res://assets/sprites/enemies/%s.png" % [_sprite])
	self.shield = _shield
