extends HBoxContainer

onready var g = $"/root/Globals";

export var value = 1 setget setValue;

func _ready():
	updateLabel();
	g.connect("feathersUpdated", self, "updateLabel");

func setValue(v):
	value = v;
	updateLabel();
	
func updateLabel():
	$LabelFeathers.text =  "- " + str(value);
	overrideLabelColor(g.feathers);
	
func overrideLabelColor(price):
	if(price >= value):
		$LabelPrice.add_color_override("font_color", Color("fff"));
	else:
		$LabelPrice.add_color_override("font_color", Color("d83300"));
