extends Control

export var title: String = "Upgrade Name";
export var price: int = 0;
export var level: int = 0;

func _ready():
	$LabelTitle.text = title;
	updateUi();
	
func updateUi():
	$LabelPrice.text = "$" + String(price);
	if(level > 0):
		$LabelLevel.text = String(level);
	else:
		$LabelLevel.text = "";


func _on_MouseOverlay_button_down():
	level = level + 1;
	$CPUParticles2D.restart();
	updateUi();
	pass # Replace with function body.
