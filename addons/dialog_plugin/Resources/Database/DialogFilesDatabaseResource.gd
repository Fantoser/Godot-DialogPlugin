tool
extends DialogDatabaseResource

var DialogUtil := load("res://addons/dialog_plugin/Core/DialogUtil.gd")

func _init() -> void:
	resource_type = DialogFileResource
	scanned_directory = DialogResources.CHARACTERS_DIR


func add(item:DialogFileResource) -> void:
	DialogUtil.Logger.print(self, ["Adding a file: ", item.resource_path])
	if resources.get_resources().has(item):
		push_warning("A resource is already there")
		var _r_array = resources.get_resources()
		var _idx = _r_array.find(item)
		if _idx != -1:
			_r_array[_idx] = item
			save(DialogResources.DIALOGFILEDB_PATH)
			emit_signal("changed")
		return
	
	(resources as ResourceArray).add(item)
	save(DialogResources.DIALOGFILEDB_PATH)
	emit_signal("changed")


func remove(item:DialogFileResource) -> void:
	DialogUtil.Logger.print(self,["removing a file:",item.resource_path])
	(resources as ResourceArray).remove(item)
	save(DialogResources.DIALOGFILEDB_PATH)
	emit_signal("changed")

func _to_string() -> String:
	return "[DialogFileDatabase]"
