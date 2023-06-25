extends Resource
class_name Upgrade

signal level_updated
signal cost_updated

export var level = 0
export var max_level = 20
export var base_price = 5

func levelUp() -> bool:
	print("override this")
	return true
