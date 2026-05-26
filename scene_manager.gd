class_name GlobalSceneManager
extends Node

enum Scene {
	NONE,
	MENU,
	HOW_TO_PLAY,
	DRAFT,
	BATTLE,
	SCENE_COUNT
}


@export var goto_scene: Scene = Scene.NONE
@export var timer_to_next_scene: float = 1.0
@export var transition_speed: float = 3.0
@export var default_scene_path: String = "res://scenes/router/router.tscn"

var scene_map_: Dictionary
var fname_map_: Dictionary
var circle_: UtilTransitionCircle


func register(fname: String, scene: Scene):
	scene_map_[fname] = scene
	fname_map_[scene] = fname


func _ready() -> void:
	var canvas := CanvasLayer.new()
	canvas.follow_viewport_enabled = true
	canvas.layer = 2
	add_child(canvas)
	
	circle_ = UtilTransitionCircle.new()
	canvas.add_child(circle_)
	
	process_mode = PROCESS_MODE_ALWAYS
	get_tree().paused = true
	
	register("res://scenes/menu/menu.tscn", Scene.MENU)
	register("res://scenes/draft/draft.tscn", Scene.DRAFT)
	register("res://scenes/battle/battle.tscn", Scene.BATTLE)


func _process(dt: float) -> void:
	if timer_to_next_scene >= 1.0:
		return
		
	if timer_to_next_scene == 0.0 and null != get_tree() and Scene.NONE != goto_scene:
		var new_scene := _get_filename_from_scene(goto_scene)
		var err := get_tree().change_scene_to_file(new_scene)
		if err != OK:
			get_tree().change_scene_to_file(default_scene_path)
		timer_to_next_scene += dt * transition_speed
		
	elif timer_to_next_scene < 0.0:
		timer_to_next_scene += dt * transition_speed
		if timer_to_next_scene >= 0.0:
			timer_to_next_scene = 0.0
			
	else:
		timer_to_next_scene += dt * transition_speed
		if timer_to_next_scene >= 1.0:
			get_tree().paused = false
	
	circle_.size_control = timer_to_next_scene
	circle_.queue_redraw()



func is_transitioning():
	return timer_to_next_scene < 1.0


func reload_scene() -> void:
	go_to_scene(_get_scene_from_filename(get_tree().current_scene.scene_file_path))


func go_to_scene(scene: Scene) -> void:
	if is_transitioning():
		return
	
	Global.clear_info()
	goto_scene = scene
	timer_to_next_scene = -1.0
	get_tree().paused = true


func _get_scene_from_filename(fname: String) -> Scene:
	if scene_map_.has(fname):
		return scene_map_[fname]
	else:
		push_error("Invalid scene '" + fname + "'")
		return Scene.MENU


func _get_filename_from_scene(scene: Scene) -> String:
	if fname_map_.has(scene):
		return fname_map_[scene]
	else:
		push_error("Invalid scene '" + str(scene) + "'")
		return default_scene_path
