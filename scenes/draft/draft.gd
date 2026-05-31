extends Node2D

@onready var selection_pool: Node2D = $SelectionPool
@onready var selected_team: Node2D = $SelectedTeam
@onready var check_button: Button = $CanvasLayer/UI/CheckButton
@onready var fight_button: Button = $CanvasLayer/UI/FightButton

@export var check_count: int = 2

var selected_lizard_pool: Node2D
var selected_lizard_team: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_button.disabled = true
	fight_button.disabled = true
	Global.opponent_team = Global.random_team()
	_connect_signals()

func _connect_signals() -> void:
	selection_pool.connect("lizard_selected", _lizard_selected_pool)
	selected_team.connect("lizard_selected", _lizard_selected_team)

func _lizard_selected_pool(lizard) -> void:
	selected_lizard_pool = lizard

func _lizard_selected_team(lizard) -> void:
	selected_lizard_team = lizard

func _on_add_button_pressed() -> void:
	if selected_lizard_pool and selected_lizard_team:
		selected_lizard_team.set_lizard(selected_lizard_pool)
	if selected_team.is_valid_team():
		check_button.disabled = false
		fight_button.disabled = false

func _on_fight_button_pressed() -> void:
	if selected_team.is_valid_team():  
		Global.set_lizard_team(selected_team)
		SceneManager.go_to_scene(SceneManager.Scene.BATTLE)
		print(Global.my_team)
		print(Global.opponent_team)

func _on_check_button_pressed() -> void:
	Global.set_lizard_team(selected_team)
	var hint_results := Global.generate_hints()
	selected_team.set_background_colors(hint_results)
	check_count -= 1
	if check_count <= 0:
		check_button.disabled = true
