@tool
extends Control

func _draw():
	var _center = Vector2(100.0, 100.0)
	#draw_arc(_center, 40, 0, TAU, 12, Color.BLACK, 10)
	
	draw_circle(_center, 40, Color(0, 0, 0, 0.50))
	
func _process(delta):
	queue_redraw();
