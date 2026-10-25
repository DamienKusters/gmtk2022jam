extends Node2D

onready var mechDice = preload("res://scenes/destroyer/MechanicalDice.tscn")

var fight_start_epoch: int

var health_is_simulated = true
const MAX_TIME_YEAR_HEALTH: float = 10000000.0 # 10 million years

var upgrades setget setUpgrades

func setUpgrades(value):
	upgrades = value
	for c in $diceContainer.get_children():
		c.visible = false
	for i in upgrades:
		$diceContainer.get_child(i).visible = true

func addDice(index):
	var dice = mechDice.instance()
	$diceContainer.get_child(index).add_child(dice)

func loadExistingDice():
	for i in upgrades:
		addDice(i)

func _ready():
	$ui/Control/VBoxContainer/DestroyerUpgradeButton.connect("upgrade", self, "upgrade")
	
	fight_start_epoch = Save.importSave(Enums.SaveFlag.DES_FIGHT_START_EPOCH, 0, true)
	setUpgrades(Save.importSave(Enums.SaveFlag.DES_ADD_DICE, 0, true))
	upgrade(true)
	$Timer.start()
	loadExistingDice()
	
func upgrade(skip_upgrades = false):
	if skip_upgrades == false:
		addDice(upgrades)
		setUpgrades(upgrades + 1)
	
	if health_is_simulated:
		update_simulated_health()
	else:
		update_health_text()
	
	if fight_start_epoch == 0:
		fight_start_epoch = floor(Time.get_unix_time_from_system())
		Save.exportSave(Enums.SaveFlag.DES_FIGHT_START_EPOCH, fight_start_epoch, false)

func update_simulated_health():
	var year_time_health = MAX_TIME_YEAR_HEALTH
	for i in range(upgrades):
		year_time_health /= 2.0
	
	if year_time_health <= 1000:
		health_is_simulated = false
		return update_health_text()
	$"%HealthLabel".text = get_simulated_health_text(year_time_health)

func update_health_text():
	var now = floor(Time.get_unix_time_from_system())
	var remaining = Globals.get_destroyer_time_remaining_epoch(upgrades)
	if remaining - now <= 0:
		$ui/Control/MenuButtons._on_back_button_clicked()
	$"%HealthLabel".text = get_health_text(now, remaining)
	print($"%HealthLabel".text)

# Returns health text that does not update
func get_simulated_health_text(years: float) -> String:
	var text = "..."
	
	if years == MAX_TIME_YEAR_HEALTH:
		return text
	if years > 1000000:
		text = String(stepify(years / 1000000, 0.1)) + " million years"
	elif years > 1000:
		text = String(round(years / 1000)) + " thousand years"
	else:
		text = String(round(years)) + " years"
	
	return text

func get_health_text(now_epoch: float, epoch: float) -> String:
	var current = Time.get_datetime_dict_from_unix_time(now_epoch)
	var target = Time.get_datetime_dict_from_unix_time(epoch)
	if now_epoch >= epoch:
		return "DESTROYED"
	
	var years = int(target.year) - int(current.year)
	var months = int(target.month) - int(current.month)
	var days = int(target.day) - int(current.day)
	
	var hours = int(target.hour) - int(current.hour)
	var minutes = int(target.minute) - int(current.minute)
	var seconds = int(target.second) - int(current.second)
	
	# Normalize values to avoid negatives
	if seconds < 0:
		seconds += 60
		minutes -= 1
	if minutes < 0:
		minutes += 60
		hours -= 1
	if hours < 0:
		hours += 24
		days -= 1
	if days < 0:
		# Simplified: assume previous month has 30 days
		days += 30
		months -= 1
	if months < 0:
		months += 12
		years -= 1
	
	# Prevent negative display
	if years < 0:
		years = 0
		months = 0
		days = 0
		hours = 0
		minutes = 0
		seconds = 0
	
	if years > 0:
		return "{y} years, {m} months".format({
			"y": years,
			"m": months,
		})
	elif months > 0:
		return "{m} months, {d} days".format({
			"m": months,
			"d": days,
		})
	elif days > 0:
		return "{d} days, {h}:{mm}:{s}".format({
			"d": days,
			"h": str(hours).pad_zeros(2),
			"mm": str(minutes).pad_zeros(2),
			"s": str(seconds).pad_zeros(2),
		})
	else:
		return "{h}:{mm}:{s}".format({
			"h": str(hours).pad_zeros(2),
			"mm": str(minutes).pad_zeros(2),
			"s": str(seconds).pad_zeros(2),
		})

func _on_Timer_timeout():
	if health_is_simulated:
		return
	update_health_text()
