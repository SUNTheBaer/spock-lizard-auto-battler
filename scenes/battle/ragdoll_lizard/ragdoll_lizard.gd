class_name RagdollLizard
extends Node2D

@export var lizard_type: String: set = _set_lizard_type
@export var flipped: bool
@export var ttl: float = 2.0

var data_: LizardConfig
var velocity_: Vector2
var rotation_: float
var accum_: float


func _set_lizard_type(value: String) -> void:
	lizard_type = value
	_sync()


func _ready() -> void:
	velocity_ = Vector2(randf_range(128.0, 512.0) * (1 if flipped else -1), -randf_range(400.0, 800.0))
	print(velocity_)
	rotation_ = randf_range(-TAU, TAU)


func _process(dt: float) -> void:
	accum_ += dt
	if accum_ > ttl:
		queue_free()
	
	global_position += velocity_ * dt
	velocity_ += Vector2(0.0, 1024.0) * dt
	rotation += rotation_ * dt
	modulate.a = 1.0 - minf(1.0, accum_ / ttl)


func _sync() -> void:
	data_ = Global.config_resource.sprite_data.get(lizard_type)
	
	if has_node("Sprite"):
		($Sprite as AnimatedSprite2D).sprite_frames = data_.visuals
	else:
		push_warning(name, " has no Sprite configured?")
