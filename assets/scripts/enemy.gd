extends Control

onready var g = $"/root/Globals";

var enemy = {};
var timeLeft = -1;
var enemyHealth = 0;

func _ready():
	g.connect("damageEnemy", self, "damage");
	respawnEnemy();
	pass
	
func respawnEnemy():
	#TODO: Rarity
	enemy = g.getEnemyFromPool();
	$LabelEnemy.text = enemy['name'];
	$EnemyContainer/TextureEnemy.texture = load(enemy['sprite']);
	$LabelTimer.text = String(enemy['time']);
	$LabelBounty.text = "+ $" + String(enemy['currency']);
	$Control/ProgressBar.max_value = enemy['health'];
	$Control/ProgressBar.value = enemy['health'];
	enemyHealth = enemy['health'];
	timeLeft = enemy['time'];
	$EnemyContainer/AnimationPlayer.play("spawn");

func damage(value: int, dice: Node2D):
	enemyHealth = enemyHealth - value;
	if(enemyHealth <= 0):
		g.addCurrency(enemy['currency']);
		$AudioMoney.play();
		respawnEnemy();
	else:
		$Control/ProgressBar.value = enemyHealth;
		$EnemyContainer/AnimationPlayerDamage.play("damage");
		$AudioDamage.play();
	pass

func _on_Timer_timeout():
	timeLeft = timeLeft -1;
	$LabelTimer.text = String(timeLeft);
	if(timeLeft < 0):
		respawnEnemy();
	pass # Replace with function body.
