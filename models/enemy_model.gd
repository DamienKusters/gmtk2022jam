class_name EnemyModel

export var name = "";
export var health = 0;
export var currency = 0;
export var sprite = "";
export var feather = 0;#External?
#export var shield = Globals.DiceEnum.D4;#TODO: array?

func _init(name: String, health: int, currency: int, sprite: String = name, shield = null):
	self.name = name
	self.health = health
	self.currency = currency
	self.sprite = sprite
#	self.shield = shield
