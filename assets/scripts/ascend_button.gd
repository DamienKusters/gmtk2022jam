extends NinePatchRect

func _ready():
	var _a = Globals.connect("feathersUpdated", self, "change_visible")
	var _b = Globals.connect("boltsUpdated", self, "change_visible")
	var _c = Globals.connect("dFeathersUpdated", self, "change_visible")
	change_visible(Globals.feathers + Globals.bolts + Globals.dFeathers)

func change_visible(f):
	visible = f > 0

func _on_Button_pressed():
	$"../AscendFlash".ascend()
