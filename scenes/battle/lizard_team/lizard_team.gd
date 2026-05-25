class_name LizardTeam
extends Node2D

signal done_animating

@export var team_composition: PackedStringArray

@export_group("Internal")
@export var lizard_scene: PackedScene
@export var ragdoll_scene: PackedScene
@export var position_separator: float = 64.0 # distance between spawns (can be negative)
@export var shift_time: float = 0.25

var accum_: float = 1.0
var base_positions_: PackedFloat32Array
var base_offsets_: PackedFloat32Array


func current_lizard() -> String:
	if 0 == get_child_count():
		return ""
	return get_child(0).lizard_type


func is_defeated() -> bool:
	return 0 == get_child_count()


func defeat() -> void:
	if accum_ < 1.0:
		await done_animating
	
	if 0 == get_child_count():
		return
	
	var front := get_child(0) as CombatLizard
	
	var ragdoll := ragdoll_scene.instantiate() as RagdollLizard
	ragdoll.lizard_type = front.lizard_type
	ragdoll.flipped = front.flipped
	ragdoll.global_position = front.global_position
	owner.add_child(ragdoll)
	
	remove_child(front)
	front.queue_free()
	
	accum_ = 0.0
	base_positions_.clear()
	for i in get_child_count():
		base_positions_.push_back(get_child(i).position.x)


func _ready() -> void:
	var delay := randf_range(0.05, 0.15)
	for i in mini(team_composition.size(), Global.config_resource.team_size):
		var lizard := lizard_scene.instantiate() as CombatLizard
		lizard.lizard_type = team_composition[i]
		lizard.position = Vector2(position_separator * i, 0.0)
		lizard.flipped = 0 < position_separator # TODO make sure this lines up with the art assets
		lizard.delay = delay
		lizard.done_animating.connect(_handle_animation_complete, CONNECT_ONE_SHOT)
		delay += randf_range(0.05, 0.15)
		add_child(lizard)


func _process(dt: float) -> void:
	if accum_ >= 1.0:
		return
	
	accum_ = minf(1.0, accum_ + dt / (shift_time * get_child_count()))
	for i in get_child_count():
		get_child(i).position.x = lerpf(
			base_positions_[i],
			base_positions_[i] - position_separator,
			Global.config_resource.bounce_curve.sample_baked(
				clampf(accum_ * get_child_count() - float(i), 0.0, 1.0))
			)
	
	if accum_ >= 1.0:
		done_animating.emit()


func _handle_animation_complete() -> void:
	for i in get_child_count():
		if get_child(i).is_entering():
			return
	done_animating.emit()
