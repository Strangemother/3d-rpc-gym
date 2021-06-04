extends Node


func load_builder(parent):
	# Name -> Scene; loaded dictionary
	var structures:Dictionary = load_structures("res://configs/structures.json")

	# Map a key value from definition to entity, if the node definition is not
	# supplied, use the default. Null arguments are not altered.
	var simple_keys = load_json_file("res://configs/simple_keys.json")
	# Map params to methods within the ComplexFunction set.
	var complex_keys = load_json_file("res://configs/complex_keys.json")

	# Generator unit.
	var builder = load("res://scripts/Builder.gd").new(structures, complex_keys, simple_keys, parent)
	return builder


func load_json_file(filepath):
	var file = File.new()
	file.open(filepath, file.READ)
	var text = file.get_as_text()
	# dict.parse_json(text)
	var data = load_json(text)
	file.close()
	return data
	#get_node("Area/Panel/Label").set_text(dict["text_1"])


func load_json(text_json:String):
	# var text_json = "{\"error\": false, \"data\": {\"player_id\": 1}}"
	var result_json = JSON.parse(text_json)
	#var result = {}

	if result_json.error == OK:  # If parse OK
		var data = result_json.result
		return data
	else:  # If parse has errors

		print("Error: ", result_json.error)
		print("Error Line: ", result_json.error_line)
		print("Error String: ", result_json.error_string)


func load_patches(fp:String):
	var res = {}
	var structures = load_json_file(fp)
	for key in structures:
		var v:String = structures[key]
		res[key] = ProjectSettings.load_resource_pack(v)
	return res


func load_structures(fp:String):
	var res = {}
	var structures = load_json_file(fp)
	for key in structures:
		var v:String = structures[key]
		res[key] = load(v)
	return res


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
