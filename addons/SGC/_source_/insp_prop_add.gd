#ALERT:DEPRECATED

extends Button
class_name SGC_PropAddComponent

var target : Node

signal dropped

func add_component(file : String) -> void:
	var _script = load(file)
	
	if _script is GDScript:
		target.add_child(_script.new())
	
	dropped.emit()

func _init() -> void:
	text = "Drop Script Component"
	icon = preload("res://addons/SGC/misc/role_icon.png")
	
	add_theme_stylebox_override("normal", preload("res://addons/SGC/misc/btn_stylenormal.tres"))

func _enter_tree() -> void:
	return

func _exit_tree() -> void:
	return

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if data and data.type == "files" and data.files.size() == 1:
		if target is Node:
			add_component(data.files[0])
