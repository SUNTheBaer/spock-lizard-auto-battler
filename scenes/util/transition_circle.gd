class_name UtilTransitionCircle
extends Control

@export var size_control: float


func _draw() -> void:
	global_position = Vector2()
	var vp := get_viewport_rect().size
	var radius := sqrt(vp.x * vp.x + vp.y * vp.y) + 64.0
	var p := (vp / 2.0) \
		if null == get_viewport().get_camera_2d() \
		else get_viewport().get_camera_2d().global_position
	if size_control < 0.0:
		draw_circle(p, radius * (1.0 + size_control), Color.BLACK)
	else:
		draw_circle(p, radius * (1.0 - min(1.0, size_control)), Color.BLACK)
