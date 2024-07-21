extends EditorInspectorPlugin

const TreeComponentButtons = {
	REMOVE_COMPONENT_OR_PROPERTY = 0,
	TOGGLE_COMPONENT_ACTIVE  = 1
}

func update_compo_items(target : Object) -> void:
	if target is Node:
		for i in target.get_child_count():
			if target.get_child(i) is SGCComponent:
				create_component_item(target.get_child(i))


func create_tree_components(target : Object) -> void:
	var _tree = Tree.new()
	var _tree_root = _tree.create_item(null)
	_tree.hide_root = true
	_tree.custom_minimum_size.y = 200
	
	var components_count = 0
	
	if target is Node:
		for i in target.get_child_count():
			if target.get_child(i) is SGCComponent:
				var _tree_item = _tree.create_item(_tree_root, i)
				_tree_item.set_icon		(0, preload("res://addons/SGC/misc/component_icon.png"))
				_tree_item.set_text		(0, target.get_child(i).name)
				_tree_item.add_button	(0, preload("res://addons/SGC/misc/Remove.svg"), TreeComponentButtons.REMOVE_COMPONENT_OR_PROPERTY, false, "Delete Component")
				_tree_item.set_meta		("node_target", target.get_child(i))
				_tree_item.set_editable	(0, true)
				_tree_item.add_button	(0, preload("res://addons/SGC/misc/active_icon.png"), TreeComponentButtons.TOGGLE_COMPONENT_ACTIVE, false, "Deactive/Active Component")
				
				if not target.get_child(i).active:
					_tree_item.set_button_color(0, TreeComponentButtons.TOGGLE_COMPONENT_ACTIVE, _tree_item.get_button_color(0, TreeComponentButtons.TOGGLE_COMPONENT_ACTIVE).inverted())
				
				for j in target.get_child(i).get_child_count():
					if target.get_child(i).get_child(j) is SGCComponentProperty:
						var _tree_item_property = _tree_item.create_child(j)
						
						if target.get_child(i).get_child(j).group:
							_tree_item_property.set_icon(0, preload("res://addons/SGC/misc/component_property_group_icon.png"))
						else:
							_tree_item_property.set_icon(0, preload("res://addons/SGC/misc/component_property_icon.png"))
						
						_tree_item_property.set_text		(0, "%s" % target.get_child(i).get_child(j).name)
						_tree_item_property.add_button		(0, preload("res://addons/SGC/misc/Remove.svg"), TreeComponentButtons.REMOVE_COMPONENT_OR_PROPERTY, false, "Delete Property")
						_tree_item_property.set_meta		("node_target", target.get_child(i).get_child(j))
						_tree_item_property.set_editable	(0, true)
						
				components_count += 1
	
	_tree.button_clicked.connect(
		func(_item : TreeItem, _column, _id, _btn_idx):
			match _id:
				TreeComponentButtons.REMOVE_COMPONENT_OR_PROPERTY:
					if _item.has_meta("node_target"):
						_item.get_meta("node_target", Node.new()).queue_free()
						_item.free()
				
				TreeComponentButtons.TOGGLE_COMPONENT_ACTIVE:
					if _item.has_meta("node_target"):
						_item.get_meta("node_target").active = not _item.get_meta("node_target").active
						_item.set_button_color(0, TreeComponentButtons.TOGGLE_COMPONENT_ACTIVE, _item.get_button_color(0, TreeComponentButtons.TOGGLE_COMPONENT_ACTIVE).inverted())
			)
		
	_tree.item_edited.connect(
		func():
			var _tree_item_selected = _tree.get_selected()
			
			if _tree_item_selected.has_meta("node_target"):
				if _tree_item_selected.get_text(0).length() < 1:
					_tree_item_selected.set_text(0, "SGCComponent_%s" % randi())
				
				_tree_item_selected.get_meta("node_target").name = _tree_item_selected.get_text(0)
	)
	
	if components_count > 0:
		var _lb = Label.new()
		_lb.text = "All Components (%s)" % components_count
		_lb.label_settings  =LabelSettings.new()
		_lb.label_settings.font_color = Color.DARK_GRAY
		_lb.label_settings.font_size = 12
		
		add_custom_control(_lb)
		add_custom_control(_tree)

func _parse_begin(object: Object) -> void:
	if object is SGCComponent:
		return
	
	if object is SGCComponentProperty:
		return
	
	if object is Node:
		var _hb = HBoxContainer.new()
		_hb.add_child(Label.new())
		_hb.add_child(VSeparator.new())
		_hb.add_child(Label.new())
		
		_hb.get_child(0).text = "Active"
		_hb.get_child(2).text = "Name"
		
		#add_custom_control(_hb)
		#update_compo_items(object)
		create_tree_components(object)
		
		var _add_prop = SGC_PropAddComponent.new()
		_add_prop.target = object
		
		#add_custom_control(_add_prop)
		#add_custom_control(HSeparator.new())
	
func _can_handle(object: Object) -> bool:
	return true

func create_component_item(target : SGCComponent) -> void:
	if not target:
		return
	
	var _hbox = HBoxContainer.new()
	var _compo_active_check = CheckBox.new()
	var _compo_icon_scr = TextureRect.new()
	var _compo_remove = Button.new()
	var _compo_lb = Label.new()
	var _compo_edit_btn = Button.new()
	
	_compo_active_check.button_pressed = target.active
	_compo_active_check.toggled.connect(
		func(_active : bool):
			target.active = _active)
	
	_compo_icon_scr.texture = preload("res://addons/SGC/misc/ScriptExtend.svg")
	_compo_icon_scr.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	_compo_icon_scr.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	
	_compo_remove.icon = preload("res://addons/SGC/misc/Remove.svg")
	_compo_remove.button_down.connect(
		func():
			target.queue_free()
			_hbox.queue_free())
	
	_compo_lb.text = target.name.capitalize()
	_compo_lb.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_compo_lb.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_compo_lb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_compo_lb.auto_translate = true
	_compo_lb.text_direction = Control.TEXT_DIRECTION_AUTO
	
	_compo_edit_btn.tooltip_text = "Edit object role params."
	_compo_edit_btn.icon = preload("res://addons/SGC/misc/Edit.svg")
	
	_hbox.add_child(_compo_active_check)
	_hbox.add_child(_compo_icon_scr)
	_hbox.add_child(_compo_lb)
	#_hbox.add_child(_compo_edit_btn)
	_hbox.add_child(_compo_remove)
	
	add_custom_control(HSeparator.new())
	
	add_custom_control(_hbox)
	
	#add_custom_control(HSeparator.new())
