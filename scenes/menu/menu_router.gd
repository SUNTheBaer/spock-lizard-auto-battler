class_name MenuRouter
extends Node

func play() -> void:
	SceneManager.go_to_scene(SceneManager.Scene.DRAFT)


func exit() -> void:
	get_tree().quit()
