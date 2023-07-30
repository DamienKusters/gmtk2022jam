extends TextureRect

func setData(dice):
	var data = Globals.getDiceData(dice);
	self_modulate = data['color'];
	$Label.text = "D"+str(data['value']);
