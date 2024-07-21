@tool

extends Node
class_name SGCComponentProperty

enum PropertyTypes {
	NULL = TYPE_NIL,
	STRING = TYPE_STRING,
	INT = TYPE_INT,
	REAL = TYPE_FLOAT,
	BOOL = TYPE_BOOL,
	VEC2 = TYPE_VECTOR2,
	IVEC2 = TYPE_VECTOR2I,
	VEC3 = TYPE_VECTOR3,
	IVEC3 = TYPE_VECTOR3I,
	VEC4 = TYPE_VECTOR4,
	IVEC4 = TYPE_VECTOR4I,
	OBJECT_OR_RES = TYPE_OBJECT,
	DICT = TYPE_DICTIONARY,
	STRINGNAME = TYPE_STRING_NAME,
	ARRAY = TYPE_ARRAY,
	COLOR = TYPE_COLOR,
	A2B2 = TYPE_AABB,
	CALL = TYPE_CALLABLE,
	NODEPATH = TYPE_NODE_PATH,
	MAT2X3 = TYPE_TRANSFORM2D,
	MAT3X3 = TYPE_BASIS,
	MAT3X4 = TYPE_TRANSFORM3D,
	MAT4X4 = TYPE_PROJECTION,
	RECT2 = TYPE_RECT2,
	RECT2I = TYPE_RECT2I,
	PLANE = TYPE_PLANE,
}


@export var property : PropertyTypes = PropertyTypes.NULL : set = _set_property
@export var group : SGCPropertyGroup = null : set = _set_group

var value = null

func _set_group(_new_group : SGCPropertyGroup) -> void:
	group = _new_group

func _get_configuration_warnings() -> PackedStringArray:
	return PackedStringArray(["A 'ComponentProperty' node must have a parent of type 'SGCComponent'."]) if not get_parent() is SGCComponent else PackedStringArray([])

func _set_property(_typeid) -> void:
	property = _typeid
	notify_property_list_changed()

func _validate_property(property: Dictionary) -> void:
	return

func _get_property_list() -> Array[Dictionary]:
	var properties : Array[Dictionary]
	var usage = PROPERTY_USAGE_DEFAULT
	
	if property == PropertyTypes.NULL:
		usage = PROPERTY_USAGE_NO_EDITOR
	
	properties.append({
		"name": "value",
		"type": property,
		"usage": usage,
		#"hint": 0,
		#"hint_string": "desc"
	})
	
	return properties
