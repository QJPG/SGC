extends Node
class_name SGCComponent

@export var active := true : set = _set_active, get = _get_active

func _set_active(_active : bool) -> void:
	active = _active
	
	set_process(active)
	set_process_input(active)
	set_physics_process(active)
	set_process_unhandled_input(active)
	set_process_unhandled_key_input(active)

func _get_active() -> bool:
	return active

func get_property(unique_name := "") -> SGCComponentProperty:
	for child in get_children():
		if child is SGCComponentProperty:
			if unique_name.length() > 0:
				if child.name == unique_name:
					return child
			else:
				return child
	
	return null

func get_properties(from_group : SGCPropertyGroup = null) -> Array[SGCComponentProperty]:
	var res : Array[SGCComponentProperty]
	
	for child in get_children():
		if child is SGCComponentProperty:
			if from_group:
				if child.group == from_group:
					res.append(child)
			else:
				res.append(child)
	
	return res
