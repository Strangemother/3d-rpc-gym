extends Node



class ComplexFunctions:
	var complex_keys
	
	func _init(complex:Dictionary):
		complex_keys=complex
	
	func call_complex_methods(e, node_definition):
		print('call_complex_methods ', self.complex_keys)	
		for key in self.complex_keys:
			var val = complex_keys[key]
			#DevTools.println(str('calling ', val, ' ', key))
			self.callv(val, [e, node_definition, key])
			
	func apply_color(e, node_definition, prop='color'):
		var color = node_definition.get(prop, null)
		if color:
			e.color = Color(color)
			
	func apply_vector(e, node_definition, prop='rotation'):
		var p = node_definition.get(prop,null)
		if p == null:
			return
		var v = Vector3(p[0], p[1], p[2])
#		e.callv(prop, [v])
		e.set(prop, v)
					
	func apply_position(e, node_definition, prop='position'):
		var p:Array = node_definition.get(prop,[0, 0, 0])	
		e.translate_object_local(Vector3(p[0], p[1], p[2]))
		

var complex_functions:ComplexFunctions# = ComplexFunctions.new(complex_keys)
var structures:Dictionary
var simple_keys:Dictionary
export var parent_path:NodePath = NodePath('.')
var _parent

# This is the constructor of the class file's main class.
func _init(object_structures, complex, simple, parent=null):
	complex_functions  = ComplexFunctions.new(complex)
	structures = object_structures
	simple_keys = simple
	if parent:
		if parent is NodePath:
			_parent = get_node(parent)
		else:
			_parent = parent
	else:
		_parent = get_node(parent_path)


func add_all(items):
	var res:Array = []
	
	for item in items:
		var e = build_custom(item)
		#e.rotation = Vector3(1,1,.5)
		_parent.add_child(e)
		res.append(e)
		print('rotation ',_parent.rotation)
	return res 


func build_custom(definition:Dictionary):
	# Build a model from definitions only.
	var parent = build_custom_child_node(definition, null, definition) # Spatial.new()
	parent.name = definition.get("name", 'default_name')
	
#	for node_definition in definition.get('nodes'):
#		var child_node = build_custom_child_node(node_definition, parent, definition)
#		parent.add_child(child_node)

	return parent

	
func build_custom_child_node(node_definition, _inner_parent, _definition):
	# Given a unique node definition (A subnode) a spatial instance (the parent)
	# and the original owning definition as a reference, construct and return
	# the node, ready for scene addition.
	
	# new node type.
	var _type = node_definition.get('type')
	var e#:PackedScene,Spatial
	#var special:bool = false 
	
	# New entity.
	if _type == null:
		e = Spatial.new()
	else:
		e = structures.get(_type).instance()
		#special = true 


	var children = node_definition.get('nodes',null)
	if children != null:
		render_children(children, e, node_definition)

	copy_simple_props(e, node_definition)	
	complex_functions.call_complex_methods(e, node_definition)
	
	return e


func render_children(children, e, node_definition):
	# set nested children.
	for child_node_definition in children:
		var child_node = build_custom_child_node(child_node_definition, e, node_definition)
		e.add_child(child_node)


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
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
