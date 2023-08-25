extends NinePatchRect

func _ready():
	var _a = Globals.connect("feathersUpdated", self, "change_visible")
	change_visible(Globals.feathers)

func change_visible(f):
	visible = f > 0

func _on_Button_pressed():
	$"../AscendFlash".ascend()
