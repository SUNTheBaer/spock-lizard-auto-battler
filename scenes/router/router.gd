class_name LandingRouter
extends Node

@export var config: GlobalConfig


func _ready() -> void:
	Global.configure(config)
	if OS.has_feature("debug_battle"):
		Global.my_team = Global.random_team()
		Global.opponent_team = Global.random_team()
		SceneManager.go_to_scene.call_deferred(SceneManager.Scene.BATTLE)
	elif OS.has_feature("debug_draft"):
		SceneManager.go_to_scene.call_deferred(SceneManager.Scene.DRAFT)
	else:
		SceneManager.go_to_scene.call_deferred(SceneManager.Scene.MENU)
