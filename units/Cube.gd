extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var color:Color = Color('#880000')
export var mesh_node:NodePath = NodePath('A')
export var physics:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_color()
	get_node("CollisionShape").disabled = physics == false

func set_color():
	var mesh:MeshInstance = get_node('./A')
	var mat:Material = mesh.get_surface_material(0)#.set_shader_param("albedo", color)
	mat.albedo_color = color

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
