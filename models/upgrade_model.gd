class_name UpgradeModel

export var title: String
export var description: String
export var texture: Texture
export var upgrade_resource: Resource

func _init(_title: String, _description: String, _texture: String, _upgrade_resource: Resource):
	self.title = _title
	self.description = _description
	self.texture = load(_texture)
	self.upgrade_resource = _upgrade_resource
