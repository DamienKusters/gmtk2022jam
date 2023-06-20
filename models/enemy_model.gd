class_name EnemyModel

export var name = "";
export var health = 0;
export var currency = 0;
export var sprite: Texture;
export var feather = 0;#External?
#export var shield = Globals.DiceEnum.D4;#TODO: array?
#TODO: abstractie???? of andere tiers?
#export var dark = false
#export var dark_name: String = self.name
#export var dark_health_multiplier: float = 2.0
#export var dark_currency_multiplier:float = 2.0
#export var dark_sprite: Texture;

func _init(name: String, health: int, currency: int, sprite: String = name, shield = null):
	self.name = name
	self.health = health
	self.currency = currency
	self.sprite = load("res://assets/sprites/enemies/%s.png" % [sprite])
#	self.shield = shield
