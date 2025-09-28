extends Control

onready var particle = preload("res://scenes/shared/single_particle_effect_enemy_death.tscn");
onready var particleLoot = preload("res://scenes/shared/single_particle_effect_get_special_loot.tscn");

onready var featherIcon = preload("res://assets/sprites/icons/angel_feather.png")
onready var boltIcon = preload("res://assets/sprites/icons/bolt.png")
onready var dFeatherIcon = preload("res://assets/sprites/icons/demon_feather.png")

onready var duBountyMultiplier = Save.importSave(Enums.SaveFlag.DU_BOUNTY_MULTIPLIER, 1)
onready var duFeatherMultiplier = Save.importSave(Enums.SaveFlag.DU_FEATHER_MULTIPLIER, 1)
onready var duSFeatherMultiplier = Save.importSave(Enums.SaveFlag.DU_SFEATHER_MULTIPLIER, 1)

var enemy: EnemyModel
var enemy_loot
var enemyHealth = 0;
var enemyShield = null;
var rng = RandomNumberGenerator.new();
var spawn_drone = false

var secondDmg = 0;

func _ready():
	var _a = Globals.connect("damageEnemy", self, "damage");
	var _b = Globals.connect("feathersUpdated", self, 'showAdvancedUi');
	var _c = Globals.connect("boltsUpdated", self, 'showAdvancedUi');
	var _d = Globals.connect("dFeathersUpdated", self, 'showAdvancedUi');
	respawnEnemy();
	$"../VBoxContainer/inventory/inv_basic".visible = true
	$"../VBoxContainer/inventory/inv_advanced".visible = false
	showAdvancedUi(0);
	
	$VBoxContainer/Label.visible = false;
	$VBoxContainer/BountyLabel.visible = false;
	$VBoxContainer/FeathersLabel.visible = false;
	$VBoxContainer/SFeathersLabel.visible = false;
	try_set_multiplier_text()
	try_set_bounty_multiplier_text()
	try_set_feather_multiplier_text()
	try_set_sfeather_multiplier_text()
	
	if duBountyMultiplier < 1:
		duBountyMultiplier = 1
	if duFeatherMultiplier < 1:
		duFeatherMultiplier = 1
	if duSFeatherMultiplier < 1:
		duSFeatherMultiplier = 1
	
	Save.connect("save_exported", self, "saveUpdated")
	saveUpdated()

func saveUpdated():
	# Spawn drone when player got harvest dice
	spawn_drone = bool(Save.importSave(Enums.SaveFlag.AS_DELETE_DICE, 0))

func respawnEnemy():
	var enemyTier: EnemyTier = Globals.getRandomEnemyTier()
	enemy = enemyTier.getRandomEnemy()
	# Only pull drone enemy (any bolt wielding enemy when harvest dice is unlocked)
	while(spawn_drone == false and enemy.loot_type == Enums.LootType.BOLTS):
		enemy = enemyTier.getRandomEnemy()
	
	enemy_loot = enemy.loot_type
	if enemy_loot == Enums.LootType.CURRENCY:
		if (enemyTier.enemyHasSpecialLoot() == true):
			enemy_loot = enemyTier.special_loot
	
	# Make the Light enemy always drop a single dark feather if the player has none.
	if Globals.dFeathers <= 0:
		if enemy == Database.enemy_pool.back().enemy_pool.back():
			enemy_loot = Enums.LootType.DARK_FEATHERS
	
	$LabelEnemy.text = enemy.name;
	$EnemyContainer/TextureEnemy.texture = enemy.sprite;
	
	$LabelEnemy/Bounty.visible = enemy_loot != Enums.LootType.CURRENCY
	$LabelEnemy/Bounty/Feather.visible = enemy_loot == Enums.LootType.FEATHERS
	$LabelEnemy/Bounty/Bolt.visible = enemy_loot == Enums.LootType.BOLTS
	$LabelEnemy/Bounty/Demon.visible = enemy_loot == Enums.LootType.DARK_FEATHERS
	if enemy_loot != Enums.LootType.CURRENCY:
		$LabelEnemy/LabelBounty.text = "";
	else:
		$LabelEnemy/LabelBounty.text = str(enemy.currency * duBountyMultiplier);
	
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
				Globals.addCurrency(enemy.currency * duBountyMultiplier)
				$AudioMoney.play()
			Enums.LootType.FEATHERS:
				Globals.addFeathers(1 * duFeatherMultiplier)
				for i in clamp(duFeatherMultiplier, 1, 10):
					spawnLootParticle(featherIcon)
			Enums.LootType.BOLTS:
				Globals.bolts += 1
				spawnLootParticle(boltIcon)
			Enums.LootType.DARK_FEATHERS:
				Globals.dFeathers += (1 * duSFeatherMultiplier)
				for i in clamp(duSFeatherMultiplier, 1, 10):
					spawnLootParticle(dFeatherIcon)
		Globals.emit_signal("enemyKilled", enemy)
		$EnemyContainer.add_child(particle.instance())
		respawnEnemy()
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

func spawnLootParticle(texture = featherIcon):
	var p = particleLoot.instance()
	p.texture = texture
	$EnemyContainer.add_child(p)

func playRandomDamageSound():
	rng.randomize()
	$AudioDamage.pitch_scale = rng.randf_range(0.80, 1.80)
	$AudioDamage.play()

func showAdvancedUi(_a):
	if Globals.feathers > 0 || Globals.bolts > 0 || Globals.dFeathers > 0:
		$"../VBoxContainer/inventory/inv_basic".visible = false
		$"../VBoxContainer/inventory/inv_advanced".visible = true

func try_set_multiplier_text():
	if Save.importSave(Enums.SaveFlag.A_MULTIPLIER_VALUE, 1) + Save.importSave(Enums.SaveFlag.AS_MULTIPLIER_VALUE, 0) > 1:
		$VBoxContainer/Label.text = "Damage x " + str(Save.importSave(Enums.SaveFlag.A_MULTIPLIER_VALUE, 1) + Save.importSave(Enums.SaveFlag.AS_MULTIPLIER_VALUE, 0))
		$VBoxContainer/Label.visible = true

func try_set_bounty_multiplier_text():
	if Save.importSave(Enums.SaveFlag.DU_BOUNTY_MULTIPLIER, 1) > 1:
		$VBoxContainer/BountyLabel.text = "Bounty x " + str(Save.importSave(Enums.SaveFlag.DU_BOUNTY_MULTIPLIER, 1))
		$VBoxContainer/BountyLabel.visible = true

func try_set_feather_multiplier_text():
	if Save.importSave(Enums.SaveFlag.DU_FEATHER_MULTIPLIER, 1) > 1:
		$VBoxContainer/FeathersLabel.text = "Feathers x " + str(Save.importSave(Enums.SaveFlag.DU_FEATHER_MULTIPLIER, 1))
		$VBoxContainer/FeathersLabel.visible = true

func try_set_sfeather_multiplier_text():
	if Save.importSave(Enums.SaveFlag.DU_SFEATHER_MULTIPLIER, 1) > 1:
		$VBoxContainer/SFeathersLabel.text = "S.Feathers x " + str(Save.importSave(Enums.SaveFlag.DU_SFEATHER_MULTIPLIER, 1))
		$VBoxContainer/SFeathersLabel.visible = true

func _on_dpsTimer_timeout():
	var damage = String(secondDmg)

	if secondDmg > 1000000:
		damage = String(round(secondDmg / 1000000)) + "M"
	elif secondDmg > 1000:
		damage = String(round(secondDmg / 1000)) + "K"
	
	$VBoxContainer/DpsLabel.text = "DPS: " + damage
	secondDmg = 0
