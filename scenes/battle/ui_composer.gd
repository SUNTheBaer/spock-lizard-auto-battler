class_name UIComposer
extends Node

@export var info_screen: Control
@export var win_scene: PackedScene
@export var lose_scene: PackedScene


func my_team_wins() -> void:
	_clear_children()
	info_screen.add_child(win_scene.instantiate())


func my_team_loses() -> void:
	_clear_children()
	info_screen.add_child(lose_scene.instantiate())


func _clear_children() -> void:
	for node in info_screen.get_children():
		node.queue_free()
