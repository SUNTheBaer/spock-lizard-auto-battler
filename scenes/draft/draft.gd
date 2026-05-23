extends Node2D

@onready var selection_pool: Node2D = $SelectionPool
@onready var selected_team: Node2D = $SelectedTeam
#@onready var add_button: Button = $AddButton

var selected_lizard_pool: Node2D
var selected_lizard_team: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
