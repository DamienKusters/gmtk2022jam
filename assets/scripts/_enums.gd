extends Node

enum DiceEnum { D4, D6, D8, D10, D12, D20, D100 };
enum Upgrade {
	ADD_DICE, UPGRADE_DICE, DUNGEON_MASTER, DICE_TOWER, REROLL,
	DICE_TRAY, CONTRACT, ROLL_DECREASE, ENHANCE_DICE, HEXAGRAM,
	QUICKROLL, OVERDRIVE, SUPER_REROLL, DELETE_DICE
};
enum LootType { CURRENCY, FEATHERS, DARK_FEATHERS, BOLTS };
#Order is crucial in this enum do not move items around:
enum SaveFlag {
	CURRENCY,
	FEATHERS,
	DARK_FEATHERS,
	BOLTS,
	
	U_ADD_DICE,
	U_UPGRADE_DICE,
	U_DUNGEON_MASTER,
	U_DICE_TOWER,
	U_REROLL,
	U_CONTRACT,
	
	U_DELETE_DICE,
	U_ENHANCE_DICE,
	U_QUICKROLL,
	U_OVERDRIVE,
	U_SUPER_REROLL,
	U_HEXAGRAM,
	
	DICE,
	TARGET_ENEMY_BEATEN,
	DARK_FEATHERS_COLLECTED,
	DESTROYER_SPAWNED,
	
	A_MULTIPLIER_VALUE,
	A_MULTIPLIER_LEVEL,
	A_REROLL_VALUE,
	A_REROLL_LEVEL,
	A_FEATHER_VALUE,
	A_FEATHER_LEVEL,
	
	AS_DELETE_DICE,
	AS_ENHANCE_DICE,
	AS_QUICKROLL,
	AS_OVERDRIVE,
	AS_SUPER_REROLL,
	AS_HEXAGRAM,
	AS_MULTIPLIER_VALUE,
	
	# DRAGON UPGRADES
	DU_BOUNTY_MULTIPLIER,
	DU_FEATHER_MULTIPLIER,
	DU_SFEATHER_MULTIPLIER,
	DU_ADD_DICE_MAX,
	DU_DM_MAX,
	DU_TRAY_MAX,
	
	# %Chance of bolts being harvested instead of usual loot
	HARVEST_DICE_BOLT_CHANCE,
	
	#TODO: ?crits
	#TODO: ?crits upgrade
	#Destroyer fight
	DES_FIGHT_START_EPOCH,
}
