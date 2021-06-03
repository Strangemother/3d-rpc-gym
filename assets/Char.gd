extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func highlight():
	$AnimationPlayer.play("TextColor")
	
func hit():
	$AnimationPlayer.play("HitAnim")
		
func fail():
	pass
	# $AnimationPlayer.play("FailAnim")
	
	#.set('.:custom_styles/normal:bg_color', '#e42424')
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
