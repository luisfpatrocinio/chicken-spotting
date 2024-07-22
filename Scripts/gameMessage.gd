extends Label
class_name GameMessage

func _ready():
	pass # Replace with function body.


func _process(delta):
	position.y -= 1;
	pass


func _on_timer_timeout():
	queue_free();
	pass # Replace with function body.
