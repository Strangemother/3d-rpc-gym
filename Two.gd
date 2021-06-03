extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var structures:Dictionary = {
	"cube": preload("res://units/Cube.tscn"),
	"sphere": preload("res://units/Sphere.tscn"),
}

var simple_keys = {
	'mass': 10, 
	'gravity_scale': 1,
	'physics': null,
	'name': null,
}


var complex_keys:Dictionary = {
	"color": "apply_color_func",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(build_custom(entity))
	add_child(build_custom(entity2))
	add_child(build_custom(ball))
	
	


var entity:Dictionary = {
	"name": "Example",
	"position": [1, 8, 1],
	"version": 1.0,
	#"physics": false,
	"nodes": [
		{
			# Parent mesh type
			"type": "cube",
			# Relative to the parent entity "Example"
			"position": [0, 0, 0],
			"color": '#000000',
			"physics": true,
			"mass": 10,
			"gravity_scale": 1,
			"nodes": [{
				# Parent mesh type
				"type": "sphere",
				# Relative to the parent entity "Example"
				"position": [1, 1, 1],
				"color": '#ff0000',
				"physics": false
			}]
		}
	]
}

var entity2:Dictionary = {
	"name": "Example2",
	"position": [1, 11, -1],
	"nodes": [
		{
			# Parent mesh type
			"type": "cube",
			# Relative to the parent entity "Example"
			"position": [0, 0, 0],
			"color": '#ff2200'
		}
	]
}

var ball:Dictionary = {
	"name": "Example2",
	"position": [-1, 12, 1],
	"nodes": [
		{
			# Parent mesh type
			"type": "sphere",
			# Relative to the parent entity "Example"
			"position": [1, 0, 0],
			"color": '#ffff00',
			"mass": 0
		}
	]
}

func build_custom(definition:Dictionary):
	# Build a model from definitions only.
	var parent = build_custom_child_node(definition, null, definition) # Spatial.new()
	parent.name = definition.get("name", 'default_name')
	
	for node_definition in definition.get('nodes'):
		var child_node = build_custom_child_node(node_definition, parent, definition)
		parent.add_child(child_node)

	return parent


func build_custom_child_node(node_definition, parent, definition):
	# Given a unique node definition (A subnode) a spatial instance (the parent)
	# and the original owning definition as a reference, construct and return
	# the node, ready for scene addition.
	
	# new node type.
	var _type = node_definition.get('type')
	var e#:PackedScene,Spatial
	var special:bool = false 
	
	# New entity.
	if _type == null:
		e = Spatial.new()
	else:
		e = structures.get(_type).instance()
		special = true 
		
#
	# set position
	var p:Array = node_definition.get("position",[0, 0, 0])	
	e.translate_object_local(Vector3(p[0], p[1], p[2]))
	copy_simple_props(e, node_definition)
	
	complex_functions.call_complex_methods(e, node_definition)
	
	if not special:
		return e 
	
	# set color
#	var color = node_definition.get("color", null)
#	if color:
#		print('set color: ', color)
#		e.color = Color(color)

	# set nested children.
	for child_node_definition in node_definition.get('nodes',[]):
		var child_node = build_custom_child_node(child_node_definition, e, node_definition)
		e.add_child(child_node)

	return e


class ComplexFunctions:
	var complex_keys
	
	func _init(complex:Dictionary):
		complex_keys=complex
	
	func call_complex_methods(e, node_definition):
		print('call_complex_methods ', self.complex_keys)	
		for key in self.complex_keys:
			var val = complex_keys[key]
			print('calling ', val)
			self.callv(val, [e, node_definition])
			
	func apply_color_func(e, node_definition):
		# set color
		var color = node_definition.get("color", null)
		if color:
			print('set color: ', color)
			e.color = Color(color)

var complex_functions:ComplexFunctions = ComplexFunctions.new(complex_keys)

func copy_simple_props(e, node_definition):
	var default
	for prop in simple_keys:
		default = simple_keys[prop]
		set_live_prop(e, prop, node_definition, default)


func set_live_prop(target, key, node_definition, default=null):
	var val = node_definition.get(key, default)
	if val == null:
		return 
	target.set(key, val)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
