class_name SceneNavigation
extends Node

@export var scene: SceneManager.Scene


func trigger() -> void:
	SceneManager.go_to_scene(scene)
