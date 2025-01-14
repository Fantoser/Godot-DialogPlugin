tool
extends Resource
class_name DialogCharacterResource

export(String) var name:String = ""
export(String) var display_name:String setget ,_get_display_name
export(bool) var display_name_bool:bool = false
export(Color) var color:Color = Color.white
export(bool) var default_speaker:bool = false # should be removed
export(String, MULTILINE) var description:String = ""
# Array of DialogPortraitResource
var portraits = PortraitArray.new() setget _set_portraits


func _get_display_name() -> String:
	if display_name_bool and display_name:
		return display_name
	else:
		return name

func get_good_name(with_name:String="") -> String:
	var _good_name = with_name
	
	if self.display_name:
		return self.display_name
	else:
		if _good_name.begins_with("res://"):
			_good_name = _good_name.replace("res://", "")
		if _good_name.ends_with(".tres"):
			_good_name = _good_name.replace(".tres", "")
		_good_name = _good_name.capitalize()
		return _good_name


func _set_portraits(value) -> void:
	portraits = value
	if not value:
		portraits = PortraitArray.new()


func _get_property_list() -> Array:
	var properties:Array = []
	properties.append(
		{
			"name":"portraits",
			"type":TYPE_OBJECT,
			"hint":PROPERTY_HINT_RESOURCE_TYPE,
			"hint_string":"PortraitArray",
		}
	)
	return properties
