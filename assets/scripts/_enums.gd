extends Node

enum DiceEnum { D4, D6, D8, D10, D12, D20 };
enum Upgrade { ADD_DICE, UPGRADE_DICE, DUNGEON_MASTER, DICE_TOWER, REROLL, DICE_TRAY, CONTRACT, ROLL_DECREASE, ASCEND };
enum LootType { CURRENCY, FEATHER, DEMON_FEATHER, BOLT };
#Order is crucial in this enum do not move items around:
enum SaveFlag {
	CURRENCY,
	FEATHERS,
	BOLTS,
	DEMON_FEATHERS,
	U_ADD_DICE,
	U_UPGRADE_DICE,
	U_DUNGEON_MASTER,
	U_DICE_TOWER,
	U_REROLL,
	U_CONTRACT,
	A_MULTIPLIER_VALUE,
	A_MULTIPLIER_LEVEL,
	A_REROLL_VALUE,
	A_REROLL_LEVEL,
	#dice levels etc oof
	#new: killed enemies for contract
}