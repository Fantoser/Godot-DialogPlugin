tool
extends VBoxContainer

var base_resource:DialogCharacterResource = null setget _set_base_resource

export(NodePath) var Name_path:NodePath
export(NodePath) var DisplayName_path:NodePath
export(NodePath) var DisplayNameBool_path:NodePath
export(NodePath) var DefaultSpeaker_path:NodePath
export(NodePath) var Description_path:NodePath
export(NodePath) var PortraitContainer_path:NodePath

onready var name_node := get_node(Name_path)
onready var display_name_node := get_node(DisplayName_path)
onready var display_name_bool_node := get_node(DisplayNameBool_path)
onready var default_speaker_node := get_node(DefaultSpeaker_path)
onready var description_node := get_node(Description_path)
onready var portrait_container_node := get_node(PortraitContainer_path)

func _ready() -> void:
	if not base_resource:
		return
	if not base_resource.is_connected("changed", self, "_on_BaseResource_changed"):
		var _err = base_resource.connect("changed", self, "_on_BaseResource_changed")
		assert(_err == OK)
	_update_values()

func _draw() -> void:
	if not visible:
		base_resource = null
	if visible and not base_resource:
		print("[Dialog] No character resource to edit")
#		visible = false

func _update_values() -> void:
	visible = true
	name_node.text = base_resource.name
	display_name_node.text = base_resource.display_name
	description_node.text = base_resource.description
	display_name_bool_node.pressed = base_resource.display_name_bool
	default_speaker_node.pressed = base_resource.default_speaker
	portrait_container_node.base_resource = base_resource


func _set_base_resource(value:DialogCharacterResource) -> void:
	base_resource = value
	if not base_resource.is_connected("changed", self, "_on_BaseResource_changed"):
		base_resource.connect("changed", self, "_on_BaseResource_changed")
	
	if is_inside_tree():
		_update_values()


func _save() -> void:
	if not base_resource:
		return
	var _err = ResourceSaver.save(base_resource.resource_path, base_resource)
	assert(_err == OK)


func _on_BaseResource_changed() -> void:
	_update_values()


func _on_DisplayName_text_changed(new_text: String) -> void:
	if not base_resource:
		return
	base_resource.display_name = new_text


func _on_DisplayNameBool_toggled(button_pressed: bool) -> void:
	if not base_resource:
		return
	base_resource.display_name_bool = button_pressed
	_save()


func _on_DefaultspeakerButton_toggled(button_pressed: bool) -> void:
	if not base_resource:
		return
	base_resource.default_speaker = button_pressed
	_save()


func _on_Description_text_changed() -> void:
	if not base_resource:
		return
	base_resource.description = description_node.text
	_save()
