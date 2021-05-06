tool
extends Control

const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
const DialogDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd")
const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")

const CharacterEditorScene = preload("res://addons/dialog_plugin/Editor/Views/character_editor/CharacterEditorView.tscn")
const TimelineEditorScene = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/TimelineEditorView.tscn")

const folderIcon = preload("res://addons/dialog_plugin/assets/Images/Resources/folder-1.25.svg")

var _editor_view:Control

onready var tree = $ViewContainer/HSplitContainer/VBoxContainer/Tree

func _ready():
#	var root = tree.create_item()
#	tree.set_hide_root(false)
#	var child1 = tree.create_item(root)
#	var child2 = tree.create_item(root)
#	var subchild1 = tree.create_item(child1)
#	root.set_text(0, "root")
#	child1.set_text(0, "child1")
#	child2.set_text(0, "child2")
#	subchild1.set_text(0, "Subchild1")
	get_dir_files(DialogResources.RESOURCES_DIR)
	if tree.get_root().get_text(0) == "":
		tree.get_root().set_text(0, DialogResources.RESOURCES_DIR)

func _build_Tree() -> void:
	pass

func get_dir_files(path: String, parent: TreeItem=null) -> PoolStringArray:
	var arr: PoolStringArray
	var dir := Directory.new()
	dir.open(path)
	var pathArray = path.rsplit("/", true, 0)

	if dir.file_exists(path):
		arr.append(path)
		var currentFile = tree.create_item(parent)
		currentFile.set_text(0, pathArray[-1])
	else:
		var currentFolder
		if parent != null and parent.get_text(0) == pathArray[-2]:
			currentFolder = tree.create_item(parent)
		else:
			currentFolder = tree.create_item()
		currentFolder.set_text(0, pathArray[-1])
		currentFolder.set_icon(0, folderIcon)
		dir.list_dir_begin(true,  true)
		while(true):
			var subpath := dir.get_next()
			if subpath.empty():
				break
			arr += get_dir_files(path.plus_file(subpath), currentFolder)

	return arr

func _on_ToolBar_character_selected(character) -> void:
	if _editor_view:
		_editor_view.queue_free()
	_editor_view = CharacterEditorScene.instance()
	_editor_view.base_resource = character
	$ViewContainer/HSplitContainer/CenterContainer.add_child(_editor_view)



func _on_ToolBar_timeline_selected(timeline) -> void:
	if _editor_view:
		_editor_view.queue_free()
	_editor_view = TimelineEditorScene.instance()
	_editor_view.base_resource = timeline
	$ViewContainer/HSplitContainer/CenterContainer.add_child(_editor_view)


#!!!!!!!!!!!!!DELETE THIS LATER!!!!!!!!!!!!!!!
func _on_TimelinesButton_pressed() -> void:
	var _position = $ReferenceRect.rect_global_position+Vector2(get_local_mouse_position().x,0)
	$TimelineListPopUp.rect_position = _position
	# Añade los items aqui
	var _timelines:Array = DialogDB.Timelines.get_timelines()
	var _items = []
	for timeline in _timelines:
		_items.append({timeline:null})
	$TimelineListPopUp.items = _items
	$TimelineListPopUp.popup()
