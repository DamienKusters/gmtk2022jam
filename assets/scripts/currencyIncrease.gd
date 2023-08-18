extends Control

var cachedValue = 0;

func _ready():
	$AnimationPlayer.play("RESET");
	Globals.connect("currencyAddedSingular", self, "currencyAddedSingular");
	
func currencyAddedSingular(value: int):
	if value > 0:
		cachedValue += value;
		$LabelBounty.text = "+ " + String(cachedValue);
		if $Timer.is_stopped():
			$Timer.start();
			$AnimationPlayer.play("fade_up");

func _on_Timer_timeout():
	cachedValue = 0;
