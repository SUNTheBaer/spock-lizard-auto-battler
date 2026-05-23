extends Node2D

enum SELECTION { ROCK, PAPER, SCISSORS, LIZARD, SPOCK, EMPTY }

signal lizard_clicked(lizard)

@export var selection: SELECTION
@export var sprite_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func set_lizard(lizard) -> void:
	sprite.texture = lizard.sprite_texture
	selection = lizard.selection

func _ready() -> void:
	sprite.texture  = sprite_texture

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		lizard_clicked.emit(self)
		anim_player.play("selected")
		anim_player.play_backwards("selected")
