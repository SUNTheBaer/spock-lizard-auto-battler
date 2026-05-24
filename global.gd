extends Node

var selected_team: Array = []

func set_lizard_team(selected_team_node: Node2D) -> void:
	var all_positions = selected_team_node.get_children()
	for i in range(0, all_positions.size()) :
		selected_team[i] = all_positions[i].get_child(-1).selection

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected_team.resize(5)
