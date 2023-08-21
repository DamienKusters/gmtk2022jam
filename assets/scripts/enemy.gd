extends Control

onready var particle = preload("res://scenes/shared/single_particle_effect_enemy_death.tscn");
onready var particleFeather = preload("res://scenes/shared/single_particle_effect_get_feather.tscn");
onready var particleDFeather = preload("res://scenes/shared/single_particle_effect_get_dfeather.tscn");

var enemy: EnemyModel
var enemy_loot
var enemyHealth = 0;
var enemyShield = null;
var rng = RandomNumberGenerator.new();

var secondDmg = 0;

func _ready():
	var _a = Globals.connect("damageEnemy", self, "damage");
	respawnEnemy();
	$"../VBoxContainer/inventory/inv_basic".visible = true
	$"../VBoxContainer/inventory/inv_advanced".visible = false
	if Globals.feathers > 0 || Globals.bolts > 0 || Globals.dFeathers > 0:
		showAdvancedUi();
	
	$VBoxContainer/Label.visible = false;
	if Globals.ascention_dps_multiplier_value > 1: 
		set_multiplier_text();
	pass
	
func respawnEnemy():
	var enemyTier: EnemyTier = Globals.getRandomEnemyTier()
	enemy = enemyTier.getRandomEnemy()
	
	enemy_loot = enemy.loot_type
	if enemy_loot == Enums.LootType.CURRENCY:
		if (enemyTier.enemyHasSpecialLoot() == true):
			enemy_loot = enemyTier.special_loot
	
	$LabelEnemy.text = enemy.name;
	$EnemyContainer/TextureEnemy.texture = enemy.sprite;
	
	$LabelEnemy/Bounty.visible = enemy_loot != Enums.LootType.CURRENCY
	$LabelEnemy/Bounty/Feather.visible = enemy_loot == Enums.LootType.FEATHERS
	$LabelEnemy/Bounty/Bolt.visible = enemy_loot == Enums.LootType.BOLTS
	$LabelEnemy/Bounty/Demon.visible = enemy_loot == Enums.LootType.DARK_FEATHERS
	if enemy_loot != Enums.LootType.CURRENCY:
		$LabelEnemy/LabelBounty.text = "";
	else:
		$LabelEnemy/LabelBounty.text = str(enemy.currency);
	
	enemyHealth = enemy.health;
	$Control/VBoxContainer/TextureProgress/Tween.stop_all()
	$Control/VBoxContainer/TextureProgress.max_value = enemy.health;
	$Control/VBoxContainer/TextureProgress.value = enemy.health;
	
	$Control/VBoxContainer/TextureProgress2.max_value = 10;
	$Control/VBoxContainer/TextureProgress2.value = 10;
	
	$EnemyContainer/AnimationPlayer.play("spawn");
	$Tween.interpolate_property($Control/VBoxContainer/TextureProgress2, "value", 10, 0, $Timer.wait_time, Tween.TRANS_LINEAR);
	$Tween.start();
	$Timer.start()
	
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
	
	var multipliedValue = value * (Globals.ascention_dps_multiplier_value + Save.importSave(Enums.SaveFlag.AS_MULTIPLIER_VALUE, 0))
	enemyHealth = enemyHealth - multipliedValue;
	secondDmg += multipliedValue;
	if(enemyHealth <= 0):
		match(enemy_loot):
			Enums.LootType.CURRENCY:
				Globals.addCurrency(enemy.currency)
				$AudioMoney.play()
			Enums.LootType.FEATHERS:
				Globals.addFeathers(1)
				$EnemyContainer.add_child(particleFeather.instance())
				showAdvancedUi()
				#TODO: save game?
			Enums.LootType.BOLTS:
				Globals.bolts += 1
				$EnemyContainer.add_child(particleDFeather.instance())
				showAdvancedUi()
				pass
			Enums.LootType.DARK_FEATHERS:
				Globals.dFeathers += 1
				$EnemyContainer.add_child(particleDFeather.instance())
				showAdvancedUi()
			
		Globals.emit_signal("enemyKilled", enemy);
		$EnemyContainer.add_child(particle.instance());
		respawnEnemy();
	else:
		$Control/VBoxContainer/TextureProgress/Tween.interpolate_property(
			$Control/VBoxContainer/TextureProgress,
			"value",
			$Control/VBoxContainer/TextureProgress.value,
			enemyHealth,
			.05
		)
		$Control/VBoxContainer/TextureProgress/Tween.start()
#		$EnemyContainer/AnimationPlayerDamage.play("damage");
		$EnemyContainer/TextureEnemy.addFade()
		$EnemyContainer/TextureEnemy.addRandomDirection()
		$EnemyContainer/TextureEnemy.addRandomRotation()
		$EnemyContainer/TextureEnemy.startAnimation()
		playRandomDamageSound();
	pass

func _on_Timer_timeout():
	respawnEnemy()

func playRandomDamageSound():
	rng.randomize()
	$AudioDamage.pitch_scale = rng.randf_range(0.80, 1.80)
	$AudioDamage.play()

func showAdvancedUi():
	$"../VBoxContainer/inventory/inv_basic".visible = false
	$"../VBoxContainer/inventory/inv_advanced".visible = true

func set_multiplier_text():
	$VBoxContainer/Label.text = "Damage x " + str(Save.importSave(Enums.SaveFlag.A_MULTIPLIER_VALUE, 1) + Save.importSave(Enums.SaveFlag.AS_MULTIPLIER_VALUE, 0))
	$VBoxContainer/Label.visible = true

func _on_dpsTimer_timeout():
	$VBoxContainer/DpsLabel.text = "DPS: " + String(secondDmg)
	secondDmg = 0
