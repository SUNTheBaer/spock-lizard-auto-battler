extends Node2D

signal lizard_selected(lizard)

@onready var position_one: Node2D = $Position1
@onready var position_two: Node2D = $Position2
@onready var position_three: Node2D = $Position3
@onready var position_four: Node2D = $Position4
@onready var position_five: Node2D = $Position5

var selected_position: Node2D

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	position_one.get_node("Lizard").connect("lizard_clicked", _lizard_selected)
	position_two.get_node("Lizard").connect("lizard_clicked", _lizard_selected)
	position_three.get_node("Lizard").connect("lizard_clicked", _lizard_selected)
	position_four.get_node("Lizard").connect("lizard_clicked", _lizard_selected)
	position_five.get_node("Lizard").connect("lizard_clicked", _lizard_selected)

func _lizard_selected(lizard) -> void:
	selected_position = lizard
	emit_signal("lizard_selected", selected_position)
