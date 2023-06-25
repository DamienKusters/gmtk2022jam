extends Control

onready var particle = preload("res://scenes/shared/single_particle_effect_enemy_death.tscn");
onready var particleFeather = preload("res://scenes/shared/single_particle_effect_get_feather.tscn");

var enemy: EnemyModel
var enemyHasFeather: bool
var timeLeft = -1;
var enemyHealth = 0;
var enemyShield = null;
var rng = RandomNumberGenerator.new();

var secondDmg = 0;

func _ready():
	Globals.connect("damageEnemy", self, "damage");
	respawnEnemy();
	$"../VBoxContainer/u_ascend".visible = false;
	$"../VBoxContainer/Control/HBoxContainer".visible = false;
	if Globals.feathers > 0:
		showAscendUpgrade();
	
	$VBoxContainer/Label.visible = false;
	if Globals.ascention_dps_multiplier_value > 1: 
		set_multiplier_text();
	pass
	
func respawnEnemy():
	var enemyTier: EnemyTier = Globals.getRandomEnemyTier()
	enemyHasFeather = enemyTier.enemyHasFeather();
	enemy = enemyTier.getRandomEnemy()
	enemyHasFeather = 	enemy.loot_type == Enums.LootType.FEATHER
	
	$LabelEnemy.text = enemy.name;
	$EnemyContainer/TextureEnemy.texture = enemy.sprite;
	
	if enemyHasFeather == true:
		$LabelEnemy/LabelBounty.text = "";
		$LabelEnemy/FeatherBounty.visible = true;
	else:
		$LabelEnemy/LabelBounty.text = str(enemy.currency);
		$LabelEnemy/FeatherBounty.visible = false;
	
	enemyHealth = enemy.health;
	$Control/VBoxContainer/TextureProgress.max_value = enemy.health;
	$Control/VBoxContainer/TextureProgress.value = enemy.health;
	
	timeLeft = 8;
	$Control/VBoxContainer/TextureProgress2.max_value = timeLeft;
	$Control/VBoxContainer/TextureProgress2.value = timeLeft;
	
	$EnemyContainer/AnimationPlayer.play("spawn");
	$Tween.interpolate_property($Control/VBoxContainer/TextureProgress2, "value", float(timeLeft), 0.1, timeLeft+1, Tween.TRANS_LINEAR);
	$Tween.start();
	
	if enemy.shield != null:
		$Shield.setData(enemy.shield);
		enemyShield = enemy.shield;
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
	
	var multipliedValue = value * Globals.ascention_dps_multiplier_value;
	enemyHealth = enemyHealth - multipliedValue;
	secondDmg += multipliedValue;
	if(enemyHealth <= 0):
		if enemyHasFeather == true:
			Globals.addFeathers(1);
			$EnemyContainer.add_child(particleFeather.instance());
			showAscendUpgrade();
		else:
			Globals.addCurrency(enemy.currency);
			$AudioMoney.play();
		Globals.killEnemy(enemy);
		$EnemyContainer.add_child(particle.instance());
		respawnEnemy();
	else:
		$Control/VBoxContainer/TextureProgress.value = enemyHealth;
		$EnemyContainer/AnimationPlayerDamage.play("damage");
		playRandomDamageSound();
	pass

func _on_Timer_timeout():
	timeLeft = timeLeft -1
	if(timeLeft < 0):
		respawnEnemy()

func playRandomDamageSound():
	rng.randomize()
	$AudioDamage.pitch_scale = rng.randf_range(0.80, 1.60)
	$AudioDamage.play()

func showAscendUpgrade():
	$"../VBoxContainer/u_ascend".visible = true;
	$"../VBoxContainer/Control/Label".align = HALIGN_LEFT;
	$"../VBoxContainer/Control/HBoxContainer".visible = true;

func set_multiplier_text():
	$VBoxContainer/Label.text = "Damage x " + String(Globals.ascention_dps_multiplier_value)
	$VBoxContainer/Label.visible = true

func _on_dpsTimer_timeout():
	$VBoxContainer/DpsLabel.text = "DPS: " + String(secondDmg)
	secondDmg = 0
