class_name WriterLabel
extends Label

signal done_clearing
signal done_writing

@export var writing: bool = true
@export var target_text: String: set = _set_target_text
@export var write_speed: float = 16.0
@export var delete_speed: float = 32.0

var current_target_text_: String
var write_value_: float = 0.0
var deleting_: bool = false


func _set_target_text(value: String) -> void:
	if target_text == value:
		return
	target_text = value
	deleting_ = true


func _ready() -> void:
	_sync_label_text()


func _process(dt: float) -> void:
	if not writing or not is_visible_in_tree():
		return
		
	if deleting_:
		write_value_ = maxf(0.0, write_value_ - delete_speed * dt)
		if write_value_ <= 0.0:
			var original_text := current_target_text_
			current_target_text_ = target_text
			deleting_ = false
			if not original_text.is_empty():
				done_clearing.emit()
	elif write_value_ < target_text.length():
		write_value_ = minf(target_text.length(), write_value_ + write_speed * dt)
		if write_value_ >= target_text.length() and not target_text.is_empty():
			done_writing.emit()
	
	_sync_label_text()


func _sync_label_text() -> void:
	text = current_target_text_.substr(0, floori(write_value_))
