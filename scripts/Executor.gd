extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func new_source(source_code:String):
	var script = GDScript.new()
	script.source_code = source_code
	script.reload()
#	var script_instance = script.new()
#	script_instance.call("say_hello")


#
#func _ready():
#	    $LineEdit.connect("text_entered", self, "_on_text_entered")

func new_expression(command):
	var expression:Expression = Expression.new()
	var error = expression.parse(command, [])
	if error != OK:
		print(expression.get_error_text())
		return
	var result = expression.execute([], null, true)
	return result
#	if not expression.has_execute_failed():
#		$LineEdit.text = str(result)


func _on_Network_source_code():
	pass # Replace with function body.
