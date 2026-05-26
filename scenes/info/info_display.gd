class_name InfoDisplay
extends Container

@export_group("Internal")
@export var title_label: Label
@export var description_label: RichTextLabel


func _ready() -> void:
	Global.info_display = self
	tree_exiting.connect(func() -> void:
		if self == Global.info_display:
			Global.info_display = null)
	configure(null)


func _process(delta: float) -> void:
	size = Vector2()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse := get_global_mouse_position()
		global_position = Vector2(
			minf(get_viewport_rect().size.x - size.x, mouse.x), 
			minf(get_viewport_rect().size.y - size.y, mouse.y))


func configure(instance: InfoInstance) -> void:
	if null == instance:
		visible = false
		return
	
	visible = true
	title_label.text = instance.title
	description_label.text = instance.description
	
