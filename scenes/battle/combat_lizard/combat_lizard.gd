class_name CombatLizard
extends Node2D

signal done_animating

@export var lizard_type: String: set = _set_lizard_type
@export var flipped: bool: set = _set_flipped
@export var delay: float

var data_: LizardConfig

var magnitude_position_: float = randf_range(48.0, 96.0)
var accum_delay_: float
var accum_position_: float
var accum_alpha_: float
var speed_position_: float = randf_range(0.8, 1.1)
var speed_alpha_: float = randf_range(0.8, 1.1)


func _set_lizard_type(value: String) -> void:
	lizard_type = value
	_sync()


func _set_flipped(value: bool) -> void:
	flipped = value
	_sync_orientation()


func is_entering() -> bool:
	return accum_position_ < 1.0 or accum_alpha_ < 1.0


func _ready() -> void:
	_sync()
	_sync_orientation()
	_sync_position()


func _process(dt: float) -> void:
	if not is_entering():
		return
	if accum_delay_ < delay:
		accum_delay_ += dt
		return
	accum_position_ = minf(1.0, accum_position_ + dt * speed_position_)
	accum_alpha_ = minf(1.0, accum_alpha_ + dt * speed_alpha_)
	_sync_position()
	if not is_entering():
		done_animating.emit()


func _sync() -> void:
	data_ = Global.config_resource.sprite_data.get(lizard_type)
	
	if has_node("Sprite"):
		($Sprite as AnimatedSprite2D).sprite_frames = data_.visuals
	else:
		push_warning(name, " has no Sprite configured?")
		
	if has_node("InfoInstance"):
		($InfoInstance as InfoInstance).title = data_.display_name
		($InfoInstance as InfoInstance).description = data_.description


func _sync_orientation() -> void:
	if has_node("Sprite"):
		($Sprite as AnimatedSprite2D).flip_h = flipped


func _sync_position() -> void:
	position.y = Global.config_resource.init_position_curve.sample_baked(accum_position_) * -magnitude_position_
	modulate.a = Global.config_resource.init_alpha_curve.sample_baked(accum_alpha_)
