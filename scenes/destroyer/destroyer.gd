extends Node2D

var fight_start_epoch: int

var health_is_simulated = true
const MAX_TIME_YEAR_HEALTH: float = 10000000.0 # 10 million years

var upgrades = 0

const EPOCH_THOUSAND_YEARS: float = 31556995200.00
const SIMULATED_UPGRADES: int = 13

var real_time_health: float

func _ready():
	fight_start_epoch = Save.importSave(Enums.SaveFlag.DES_FIGHT_START_EPOCH, 0, true)
	$ui/Control/Control/LabelEnemy2.text = get_simulated_health_text(MAX_TIME_YEAR_HEALTH)
	$Timer.start()
	
func upgrade():
	upgrades += 1
	
	if health_is_simulated:
		update_simulated_health()
	else:
		update_health()
	
	if fight_start_epoch == 0:
		fight_start_epoch = floor(Time.get_unix_time_from_system())
		# TODO: DO NOT SAVE IN FIGHT; WILL MESS WITH REAL SAVE FILE
		Save.exportSave(Enums.SaveFlag.DES_FIGHT_START_EPOCH, fight_start_epoch, true)

func update_simulated_health():
	var year_time_health = MAX_TIME_YEAR_HEALTH
	for i in range(upgrades):
		year_time_health /= 2.0
	
	if year_time_health <= 1000:
		health_is_simulated = false
		real_time_health = fight_start_epoch + EPOCH_THOUSAND_YEARS
		return update_health()
	$ui/Control/Control/LabelEnemy2.text = get_simulated_health_text(year_time_health)

func update_health():
	var now = floor(Time.get_unix_time_from_system())
	var u = upgrades - SIMULATED_UPGRADES
	
	# Start from full duration
	var total_duration = EPOCH_THOUSAND_YEARS
	
	# Halve the duration based on real upgrades
	for i in range(u):
		total_duration /= 2.0
	
	# TODO: must use fight_start_epoch to retain fight time, if using now() it will always halve it, thus punish when you take longer with the fight.
	# For 'flavour' below ~15 mins the fight should use now() instead to show the timer ticking down 
	real_time_health = fight_start_epoch + total_duration
	
	$ui/Control/Control/LabelEnemy2.text = get_health_text(now, real_time_health)

func update_health_text():
	var now = floor(Time.get_unix_time_from_system())
	$ui/Control/Control/LabelEnemy2.text = get_health_text(now, now + get_remaining_time_epoch(now))

func get_remaining_time_epoch(now):
	return real_time_health - now

func _on_Button_pressed():
	upgrade()

func _on_Button2_pressed():
	upgrade()

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
			"h": hours,
			"mm": minutes,
			"s": seconds,
		})
	else:
		return "{h}:{mm}:{s}".format({
			"h": hours,
			"mm": minutes,
			"s": seconds,
		})

func _on_Timer_timeout():
	if health_is_simulated:
		return
	update_health_text()
