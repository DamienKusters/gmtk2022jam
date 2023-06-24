class AscendResource:
	extends Resource

	signal reload;

	export var value = 0;
	export(Enums.DiceEnum) var level;

	func exportResource():
		return str(value + "/" + level);

	func importResource(res):
		var out = res.split("/",true,1);
		value = int(out[0]);
		level = int(out[1]);
		emit_signal("reload");
		pass
