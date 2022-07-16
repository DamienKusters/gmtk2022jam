extends Control

onready var g = $"/root/Globals";

var rng = RandomNumberGenerator.new();

var enemy = {};
var timeLeft = -1;
var enemyHealth = 0;

func _ready():
	g.connect("damageEnemy", self, "damage");
	respawnEnemy();
	pass
	
func respawnEnemy():
	#TODO: Rarity
	rng.randomize();
	var idx = rng.randi_range(0, g.enemiesCommon.size()-1);
	enemy = g.enemiesCommon[idx];
	$LabelEnemy.text = enemy['name'];
	$EnemyContainer/TextureEnemy.texture = load(enemy['sprite']);
	$LabelTimer.text = String(enemy['time']);
	$LabelBounty.text = "$" + String(enemy['currency']);
	$Control/ProgressBar.max_value = enemy['health'];
	$Control/ProgressBar.value = enemy['health'];
	enemyHealth = enemy['health'];
	timeLeft = enemy['time'];

func damage(value: int):
	enemyHealth = enemyHealth - value;
	if(enemyHealth <= 0):
		g.addCurrency(enemy['currency']);
		respawnEnemy();
	else:
		$Control/ProgressBar.value = enemyHealth;
	pass

func _on_Timer_timeout():
	timeLeft = timeLeft -1;
	$LabelTimer.text = String(timeLeft);
	if(timeLeft < 0):
		respawnEnemy();
	pass # Replace with function body.
