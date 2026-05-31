extends Node2D

signal lizard_selected(lizard)

@onready var position_one: Node2D = $Position1
@onready var position_two: Node2D = $Position2
@onready var position_three: Node2D = $Position3
@onready var position_four: Node2D = $Position4
@onready var position_five: Node2D = $Position5

@export var alpha_value: float = 0.2

const EMPTY_ENUM: int = 5 

var position_arrays: Array
var selected_position: Node2D

var color_dict = {
	"red": Color.RED,
	"yellow": Color.YELLOW,
	"green": Color.GREEN,
	"blue": Color.BLUE
}

func is_valid_team() -> bool:
	for position in position_arrays:
		if position.get_node("Lizard").selection == EMPTY_ENUM:
			return false
	return true

func set_background_colors(colors: PackedStringArray) -> void:
	for i in position_arrays.size():
		var color_rect = position_arrays[i].get_node("ColorRect")
		color_rect.set_color(color_dict[colors[i]])
		color_rect.color.a = alpha_value

func _ready() -> void:
	position_arrays = [position_one, position_two, position_three, position_four, position_five]
	_connect_signals()

func _connect_signals() -> void:
	for position in position_arrays:
		position.get_node("Lizard").connect("lizard_clicked", _lizard_selected)

func _lizard_selected(lizard) -> void:
	selected_position = lizard
	emit_signal("lizard_selected", selected_position)
