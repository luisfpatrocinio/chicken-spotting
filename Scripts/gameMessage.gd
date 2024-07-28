extends Label
class_name GameMessage

func _ready():
	pass # Replace with function body.


func _process(delta):
	position.y -= 0.10;
	if $Timer.time_left < 0.50:
		modulate.a = randf_range(0.20, 0.60);

func _on_timer_timeout():
	queue_free();
	pass # Replace with function body.
