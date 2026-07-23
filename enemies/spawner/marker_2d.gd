@tool
extends Marker2D

@export var position_offset_x: float = 100
@export var position_offset_y: float = 100
@export var circle_marker: bool = true:
	set(value):
		circle_marker = value
		queue_redraw() 

func _draw():
	var size = Vector2(position_offset_x * 2, position_offset_y * 2)
	var top_left = -size / 2
	var rect = Rect2(top_left, size)
	var color = Color.AQUA
	var filled = false
	var width = 5.0 
	
	draw_rect(rect, color, filled, width)
