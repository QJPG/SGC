@tool
extends EditorPlugin

var InspNodeCompo = preload("res://addons/SGC/_source_/insp_node.gd").new()

func _init() -> void:
	return

func _enter_tree() -> void:
	add_custom_type(
		"ComponentPropertyGroup",
		"SGCPropertyGroup",
		preload("res://addons/SGC/_components_/property_group.gd"),
		preload("res://addons/SGC/misc/component_property_group_icon.png")
	)
	add_custom_type(
		"Component",
		"SGCComponent",
		preload("res://addons/SGC/_components_/component_node_class.gd"),
		preload("res://addons/SGC/misc/component_icon.png"))
	add_custom_type(
		"ComponentProperty",
		"SGCComponentProperty",
		preload("res://addons/SGC/_components_/component_property.gd"),
		preload("res://addons/SGC/misc/component_property_icon.png")
	)
	
	add_autoload_singleton("SoundSourceManager", "res://addons/SGC/_singletons_/sound_source_manager.gd")
	add_inspector_plugin(InspNodeCompo)


func _exit_tree() -> void:
	remove_inspector_plugin(InspNodeCompo)
	remove_autoload_singleton("SoundSourceManager")
	
	remove_custom_type("ComponentProperty")
	remove_custom_type("Component")
	remove_custom_type("ComponentPropertyGroup")
