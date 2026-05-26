class_name InfoInstance
extends Node2D

@export var title: String
@export var description: String


func _ready() -> void:
	($Area as Area2D).mouse_entered.connect(_enter_hover)
	($Area as Area2D).mouse_exited.connect(_exit_hover)
	tree_exiting.connect(_exit_hover)


func _enter_hover() -> void:
	Global.push_info(self)


func _exit_hover() -> void:
	Global.pop_info(self)
