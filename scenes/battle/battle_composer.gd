class_name BattleComposer
extends Node2D

signal round_complete(result: String)
signal my_team_wins
signal opponent_team_wins
signal tie

@export var battle_delay: float = 1.0 # delay between rounds in seconds
@export var my_team: LizardTeam
@export var opponent_team: LizardTeam

var verb_: String
var delaying_: bool
var accum_: float
var awaiting_on_: int


func resolve_round() -> void:
	var mine := Global.config_resource.sprite_data.get(my_team.current_lizard()) as LizardConfig
	var theirs := Global.config_resource.sprite_data.get(opponent_team.current_lizard()) as LizardConfig
	
	if null == mine or null == theirs:
		return
	
	if mine.beats(opponent_team.current_lizard()):
		round_complete.emit("%s %s %s" % [
			mine.display_name,
			mine.wins_against[opponent_team.current_lizard()],
			theirs.display_name])
		
		opponent_team.defeat()
		
		awaiting_on_ = 1
		opponent_team.done_animating.connect(_handle_animation_complete, CONNECT_ONE_SHOT)
	
	elif theirs.beats(my_team.current_lizard()):
		round_complete.emit("%s %s %s" % [
			theirs.display_name,
			theirs.wins_against[my_team.current_lizard()],
			mine.display_name])
		
		my_team.defeat()
		
		awaiting_on_ = 1
		my_team.done_animating.connect(_handle_animation_complete, CONNECT_ONE_SHOT)
	
	else:
		round_complete.emit("%s ties %s" % [
			mine.display_name,
			theirs.display_name])
		
		my_team.defeat()
		opponent_team.defeat()
		
		awaiting_on_ = 2
		opponent_team.done_animating.connect(_handle_animation_complete, CONNECT_ONE_SHOT)
		my_team.done_animating.connect(_handle_animation_complete, CONNECT_ONE_SHOT)


func _ready() -> void:
	my_team.team_composition = Global.my_team
	opponent_team.team_composition = Global.opponent_team
	
	my_team.done_animating.connect(_handle_animation_complete, CONNECT_ONE_SHOT)
	opponent_team.done_animating.connect(_handle_animation_complete, CONNECT_ONE_SHOT)


func _process(dt: float) -> void:
	if delaying_:
		accum_ += dt
		if accum_ >= battle_delay:
			delaying_ = false
			resolve_round()


func _handle_animation_complete() -> void:
	awaiting_on_ -= 1
	if 0 >= awaiting_on_:
		if my_team.is_defeated() and opponent_team.is_defeated():
			tie.emit()
			return
		elif my_team.is_defeated():
			opponent_team_wins.emit()
			return
		elif opponent_team.is_defeated():
			my_team_wins.emit()
			return
		
		# If there's no winner yet then proceed
		delaying_ = true
		accum_ = 0.0
