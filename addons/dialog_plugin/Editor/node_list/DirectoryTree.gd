tool
extends VBoxContainer

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

export(PackedScene) var ItemScene:PackedScene = load("res://addons/dialog_plugin/Editor/node_list/item/item.tscn")
export(PackedScene) var FolderScene:PackedScene = load("res://addons/dialog_plugin/Editor/node_list/folder_container/folder_container.tscn")

var items:Array = []
var folders:Array = []

func add_item(item_resource:Resource=null) -> void:
	var _item_node:Control = null
	for item in items:
		_item_node = (item as Dictionary).get(item_resource, null)
	if not _item_node:
		items.append({item_resource:null})
	
	update_view()

func update_view() -> void:
	clear()
	
	for item in items:
		for item_resource in (item as Dictionary).keys():
			
			var _item_node = (item as Dictionary).get(item_resource, null)
			var _item_path:String = item_resource.resource_path
			var _item_folder:String = _item_path.get_base_dir().split("/")[-1]
			
			if not _item_node:
				_item_node = ItemScene.instance()
			
			
			_item_node.name = item_resource.resource_path.get_file().replace(".tres","")
			_item_node.text = _item_node.name
			_item_node.set_meta("base_resource", item_resource)
			
			if not(_item_node.is_connected("pressed", self, "_on_item_selected")):
				_item_node.connect("pressed", self, "_on_item_selected")
			if not(_item_node.is_connected("deletion_requested", self, "_on_item_deletion_requested")):
				_item_node.connect("deletion_requested", self, "_on_item_deletion_requested")
			

			var _node_folder = null
			for folder in folders:
				# First, check if we added the folder previously
				if _item_folder in folder:
					_node_folder = folder[_item_folder]
			# Then, if there's no folder or the previous instance doesn't exist
			# creates a new folder and update values
			if not _node_folder or not(is_instance_valid(_node_folder)):
				_node_folder = FolderScene.instance()
				folders.append({_item_folder:_node_folder})
				self.add_child(_node_folder)
				_node_folder.name = _item_folder
				_node_folder.folder_name.text = _item_folder
			_node_folder.node_container.add_child(_item_node)
			self.move_child(_node_folder, 0)

func clear() -> void:
	for child in self.get_children():
		child.queue_free()

func _on_item_selected(item:Control=null) -> void:
	if not item:
		return
	emit_signal("item_selected", item.get_meta("base_resource"))

func _on_item_deletion_requested(item:Control=null) -> void:
	if not item:
		return
