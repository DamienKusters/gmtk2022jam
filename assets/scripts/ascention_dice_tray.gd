extends HBoxContainer

enum UnitEnum {MULTIPLY,PLUS};

signal valueUpdated;

onready var g = $"/root/Globals";

export var value = 0;
export(UnitEnum) var unit;

func _ready():
	for i in get_children():
		if i != $LabelResult:
			if unit == UnitEnum.PLUS:
				i.prepend = "+";
			i.connect("valueUpdated", self, "recalculate");
	recalculate(1);
	
func recalculate(_value):
	match unit:
		UnitEnum.MULTIPLY:
			value = 1;
			for i in get_children():
				if i != $LabelResult:
					value = int(value * i.value);
			$LabelResult.text = "= x " + str(value);
		UnitEnum.PLUS:
			value = 0;
			for i in get_children():
				if i != $LabelResult:
					value += i.value;
			$LabelResult.text = "= " + str(value);
	
	emit_signal("valueUpdated", value);
