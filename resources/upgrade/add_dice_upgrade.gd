extends Upgrade
class_name AddDiceUpgrade

#TODO: override props
#export var max_level = 20

func levelUp():
#	Globals.connect("upgradeDiceSuccess", self, "applyNextLevelUiUpdate");
	Globals.addDice();
	return true
