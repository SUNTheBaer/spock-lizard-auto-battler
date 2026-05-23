extends Node2D

signal lizard_selected(lizard)

@onready var lizard_rock: Node2D = $LizardRock
@onready var lizard_paper: Node2D = $LizardPaper
@onready var lizard_scissors: Node2D = $LizardScissors
@onready var lizard_spock: Node2D = $LizardSpock
@onready var lizard_lizard: Node2D = $LizardLizard

var selected_lizard: Node2D

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	lizard_rock.connect("lizard_clicked", _lizard_selected)
	lizard_paper.connect("lizard_clicked", _lizard_selected)
	lizard_scissors.connect("lizard_clicked", _lizard_selected)
	lizard_spock.connect("lizard_clicked", _lizard_selected)
	lizard_lizard.connect("lizard_clicked", _lizard_selected)

func _lizard_selected(lizard) -> void:
	selected_lizard = lizard
	emit_signal("lizard_selected", selected_lizard)
