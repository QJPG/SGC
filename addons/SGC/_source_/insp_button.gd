#ALERT: DEPRECATED

extends "res://addons/SGC/_source_/insp_node.gd"

func _init() -> void:
	pass

func _can_handle(object: Object) -> bool:
	return object is BaseButton

func _parse_begin(object: Object) -> void:
	if object is Button:
		#WARNING: ADD ROLES HERE
		
		#create_component_item(object, "Script Test.gd", "")
		
		add_custom_control(HSeparator.new())
		
		var x = ItemList.new()
		add_custom_control(x)
		
		var _add_compo_btn = Button.new()
		_add_compo_btn.text = "Add Script Component"
		_add_compo_btn.icon = preload("res://addons/SGC/misc/role_icon.png")
		
		_add_compo_btn.button_down.connect(
			func():
				var _file_dialog = EditorFileSystemDirectory.new()
				_file_dialog.access = FileDialog.ACCESS_RESOURCES
				_file_dialog.always_on_top = true
				_file_dialog.close_requested.connect(
					func():
						_file_dialog.queue_free())
				
				)
		
		add_custom_control(_add_compo_btn)
