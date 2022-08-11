extends Control

onready var g = $"/root/Globals";

var cachedValue = 0;

func _ready():
	g.connect("currencyAddedSingular", self, "currencyAddedSingular");
	pass
	
func currencyAddedSingular(value: int):
	cachedValue += value;
	$LabelBounty.text = "+ " + String(cachedValue);
	if $Timer.is_stopped():
		$Timer.start();
		$AnimationPlayer.play("fade_up");


func _on_Timer_timeout():
	cachedValue = 0;
	pass # Replace with function body.
