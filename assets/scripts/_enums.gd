extends Node

enum DiceEnum { D4, D6, D8, D10, D12, D20, D100 };
enum Upgrade { ADD_DICE, UPGRADE_DICE, DUNGEON_MASTER, DICE_TOWER, REROLL, DICE_TRAY, CONTRACT, ROLL_DECREASE, ENHANCE_DICE, HEXAGRAM };
enum LootType { CURRENCY, FEATHERS, DARK_FEATHERS, BOLTS };
#Order is crucial in this enum do not move items around:
enum SaveFlag {
	CURRENCY,
	FEATHERS,
	BOLTS,
	DARK_FEATHERS,
	
	U_ADD_DICE,
	U_UPGRADE_DICE,
	U_DUNGEON_MASTER,
	U_DICE_TOWER,
	U_REROLL,
	U_CONTRACT,
	
	#Delete dice -> gives bolt upon deleting D100?
	U_ENHANCE_DICE,
	#Quick roll -> rolls {level} dice per manual click
	#Dice tray?
	#SUper reroller -> reroller for D100
	U_HEXAGRAM,
	#TODO: exclusive upgrade tray? ?crits
	
	DICE,
	TARGET_ENEMY_BEATEN,
	DESTROYER_SPAWNED,
	
	A_MULTIPLIER_VALUE,
	A_MULTIPLIER_LEVEL,
	A_REROLL_VALUE,
	A_REROLL_LEVEL,
	
	AS_ENHANCE_DICE,
	AS_HEXAGRAM,
}
