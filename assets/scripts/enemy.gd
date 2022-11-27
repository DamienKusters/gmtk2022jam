extends Control

onready var g = $"/root/Globals";

onready var particle = preload("res://scenes/shared/single_particle_effect_enemy_death.tscn");

var enemy = {};
var timeLeft = -1;
var enemyHealth = 0;
var enemyShield = null;
var rng = RandomNumberGenerator.new();

var secondDmg = 0;

func _ready():
	g.connect("damageEnemy", self, "damage");
	respawnEnemy();
	$"../VBoxContainer/u_ascend".visible = false;
	$"../VBoxContainer/Control/HBoxContainer".visible = false;
	if g.feathers > 0:
		showAscendUpgrade();
	pass
	
func respawnEnemy():
	#TODO: Rarity
	enemy = g.getEnemyFromPool();
	$LabelEnemy.text = enemy['name'];
	$EnemyContainer/TextureEnemy.texture = load(enemy['sprite']);
#	$LabelTimer.text = String(enemy['time']);
	if enemy["feather"] == 0:
		$LabelEnemy/LabelBounty.text = "" + String(enemy['currency']);
		$LabelEnemy/FeatherBounty.visible = false;
	else:
		$LabelEnemy/LabelBounty.text = "";
		$LabelEnemy/FeatherBounty.visible = true;
	$Control/VBoxContainer/TextureProgress.max_value = enemy['health'];
	$Control/VBoxContainer/TextureProgress.value = enemy['health'];
	enemyHealth = enemy['health'];
#	if(timeLeft == -1):
#		timeLeft = enemy['time'];
	timeLeft = 7;
	$EnemyContainer/AnimationPlayer.play("spawn");
	$Control/VBoxContainer/TextureProgress2.max_value = timeLeft;
	$Control/VBoxContainer/TextureProgress2.value = timeLeft;
	$Tween.interpolate_property($Control/VBoxContainer/TextureProgress2, "value", float(timeLeft), 0.1, timeLeft+1, Tween.TRANS_LINEAR);
	$Tween.start();
	
	if enemy['shield'] != null:
		$Shield.setData(enemy['shield']);
		enemyShield = enemy['shield'];
		$Shield/AnimationPlayer.play("spawn");
	else:
		enemyShield = null;
		$Shield/AnimationPlayer.play("RESET");

func damage(value: int, dice: Node2D):
	if enemyShield != null && dice.kind == enemyShield:
		$Shield/AnimationPlayer.play("hit");
		$AudioDamage.pitch_scale = 0.61;
		$AudioDamage.play();
		return;
	
	var multipliedValue = value * g.ascention_dps_multiplier;
	enemyHealth = enemyHealth - multipliedValue;
	secondDmg += multipliedValue;
	if(enemyHealth <= 0):
		if enemy.feather != 0:
			var featherKind = enemy['feather'];
			if(featherKind < 0):
				g.addFeathers(1);# The angel will always give feathers
			else:
				g.addFeathers(1);
				var index = g.enemiesCommon.find(enemy,0);
				var f = g.enemiesCommon[index]['feather'];
				g.enemiesCommon[index]['feather'] = f - 1;
			showAscendUpgrade();
		else:
			g.addCurrency(enemy['currency']);
		g.killEnemy(enemy);
		$AudioMoney.play();
		$EnemyContainer.add_child(particle.instance());
		respawnEnemy();
	else:
		$Control/VBoxContainer/TextureProgress.value = enemyHealth;
		$EnemyContainer/AnimationPlayerDamage.play("damage");
		playRandomDamageSound();
	pass

func _on_Timer_timeout():
	timeLeft = timeLeft -1;
	if(timeLeft < 0):
		respawnEnemy();
	pass # Replace with function body.
	
func playRandomDamageSound():
	rng.randomize();
	var pitch = rng.randf_range(0.80, 1.60);
	$AudioDamage.pitch_scale = pitch;
	$AudioDamage.play();

func showAscendUpgrade():
	$"../VBoxContainer/u_ascend".visible = true;
	$"../VBoxContainer/Control/Label".align = HALIGN_LEFT;
	$"../VBoxContainer/Control/HBoxContainer".visible = true;
	
func _on_dpsTimer_timeout():
	$Label.text = "DPS: " + String(secondDmg);
	secondDmg = 0;
	pass # Replace with function body.
