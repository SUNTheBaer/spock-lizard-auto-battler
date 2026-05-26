class_name LizardConfig
extends Resource

@export var display_name: String
@export var description: String
@export var visuals: SpriteFrames
@export var wins_against: Dictionary[String, String]


func beats(lizard_type: String) -> bool:
	return wins_against.has(lizard_type)
