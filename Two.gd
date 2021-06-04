extends Spatial

# JSON Loader tools.
var loaders = load("scripts/Loaders.gd").new()
var overrides = loaders.load_patches('res://configs/packs.json')
# unit builder
var builder = loaders.load_builder(self)

# user scenes.
var scenes:Array = loaders.load_json_file('res://configs/scenes.json')



func _ready():
	print(overrides)
	load_scenes()


func load_scenes():
	"""Scene.

		var entity:Dictionary = loaders.load_json_file("res://configs/entity.json")
		var entity2:Dictionary = loaders.load_json_file("res://configs/cube.json")
		var ball:Dictionary = loaders.load_json_file("res://configs/ball.json")

		var elements = [ball, entity, entity2]

		func _ready():
		var items = builder.add_all(elements)
		var actor = items[0]
		print('ball.axis_lock_linear_y', actor.get_node('ball').axis_lock_linear_y)

	"""

	var loaded_scenes:Array = []
	for scenepath in scenes:
		loaded_scenes.append(loaders.load_json_file(scenepath))

	var items = builder.add_all(loaded_scenes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ProximityGroup_broadcast(group_name, parameters):
	print(group_name, parameters)


func _on_ProximityGroup_body_shape_entered(body_id, body, body_shape, area_shape):
	print(body_id, body, body_shape, area_shape)
