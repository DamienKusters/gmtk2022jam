extends Control

onready var g = $"/root/Globals";

var enemy = {};
var timeLeft = -1;
var enemyHealth = 0;
var rng = RandomNumberGenerator.new();

func _ready():
	g.connect("damageEnemy", self, "damage");
	respawnEnemy();
	pass
	
func respawnEnemy():
	#TODO: Rarity
	enemy = g.getEnemyFromPool();
	$LabelEnemy.text = enemy['name'];
	$EnemyContainer/TextureEnemy.texture = load(enemy['sprite']);
#	$LabelTimer.text = String(enemy['time']);
	$LabelBounty.text = "+ $" + String(enemy['currency']);
	$Control/VBoxContainer/TextureProgress.max_value = enemy['health'];
	$Control/VBoxContainer/TextureProgress.value = enemy['health'];
	enemyHealth = enemy['health'];
	timeLeft = enemy['time'];
	$EnemyContainer/AnimationPlayer.play("spawn");
	$Control/VBoxContainer/TextureProgress2.max_value = timeLeft;
	$Control/VBoxContainer/TextureProgress2.value = timeLeft;
	$Tween.interpolate_property($Control/VBoxContainer/TextureProgress2, "value", float(timeLeft), 0.3, timeLeft+1, Tween.TRANS_SINE, Tween.EASE_IN_OUT);
	$Tween.start();

func damage(value: int, dice: Node2D):
	enemyHealth = enemyHealth - value;
	if(enemyHealth <= 0):
		g.addCurrency(enemy['currency']);
		$AudioMoney.play();
		respawnEnemy();
	else:
		$Control/VBoxContainer/TextureProgress.value = enemyHealth;
		$EnemyContainer/AnimationPlayerDamage.play("damage");
		playRandomDamageSound();
	pass

func _on_Timer_timeout():
	timeLeft = timeLeft -1;
	#$LabelTimer.text = String(timeLeft);
	#$Control/VBoxContainer/TextureProgress2.value = timeLeft;
	if(timeLeft < 0):
		respawnEnemy();
	pass # Replace with function body.
	
func playRandomDamageSound():
	rng.randomize();
	var pitch = rng.randf_range(0.80, 1.60);
	$AudioDamage.pitch_scale = pitch;
	$AudioDamage.play();
