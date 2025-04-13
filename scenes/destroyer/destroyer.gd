extends Node2D

var fight_start_epoch: int
var last_upgrade_epoch: int

var health_is_simulated = true
const max_time_year_health: float = 10000000.0 # 10 million years

var upgrades = 0

const EPOCH_THOUSAND_YEARS: float = 33301577095.00
const SIMULATED_UPGRADES: int = 14

var real_time_health: float

func _ready():
	fight_start_epoch = Save.importSave(Enums.SaveFlag.DES_FIGHT_START_EPOCH, 0, true)
	last_upgrade_epoch = Save.importSave(Enums.SaveFlag.DES_LAST_UPGRADE_EPOCH, 0, true)
	$ui/Control/Control/LabelEnemy2.text = get_simulated_health_text(max_time_year_health)
	
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
	last_upgrade_epoch = floor(Time.get_unix_time_from_system())
	# TODO: DO NOT SAVE IN FIGHT; WILL MESS WITH REAL SAVE FILE
	Save.exportSave(Enums.SaveFlag.DES_LAST_UPGRADE_EPOCH, last_upgrade_epoch, true)

func update_simulated_health():
	var year_time_health = max_time_year_health
	for i in range(upgrades):
		year_time_health /= 2.0
	
	if year_time_health <= 1000:
		health_is_simulated = false
		real_time_health = fight_start_epoch + EPOCH_THOUSAND_YEARS
		return update_health()
	$ui/Control/Control/LabelEnemy2.text = get_simulated_health_text(year_time_health)

func update_health():
	var u = upgrades - SIMULATED_UPGRADES
	for i in range(u):
		real_time_health /= 2.0
	
	$ui/Control/Control/LabelEnemy2.text = get_health_text(real_time_health)
	pass
	
func _on_Button_pressed():
	upgrade()

func _on_Button2_pressed():
	upgrade()

# Returns health text that does not update
func get_simulated_health_text(years: float) -> String:
	var text = "..."
	
	if years == max_time_year_health:
		return text
	if years > 1000000:
		text = String(stepify(years / 1000000, 0.1)) + " million years"
	elif years > 1000:
		text = String(round(years / 1000)) + " thousand years"
	else:
		text = String(round(years)) + " years"
	
	return text

func get_health_text(epoch: float) -> String:
	return String(epoch)
