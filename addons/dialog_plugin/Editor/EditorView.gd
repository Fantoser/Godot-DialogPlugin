tool
extends Control

signal item_selected(item)

const DialogResources = preload("res://addons/dialog_plugin/Core/DialogResources.gd")
const DialogUtil = preload("res://addons/dialog_plugin/Core/DialogUtil.gd")
const DialogDB = preload("res://addons/dialog_plugin/Core/DialogDatabase.gd")
const TranslationService = preload("res://addons/dialog_plugin/Other/translation_service/translation_service.gd")

const CharacterEditorScene = preload("res://addons/dialog_plugin/Editor/Views/character_editor/CharacterEditorView.tscn")
const TimelineEditorScene = preload("res://addons/dialog_plugin/Editor/Views/timeline_editor/TimelineEditorView.tscn")

const characterIcon = preload("res://addons/dialog_plugin/assets/Images/Resources/character.svg")
const timelineIcon = preload("res://addons/dialog_plugin/assets/Images/Resources/timeline.svg")

var _editor_view:Control

onready var tree = $ViewContainer/HBoxContainer/VBoxContainer/PanelContainer/DirectoryTree/Tree

func _ready() -> void:
	# Be careful when using this. It could block the main thread for a few seconds
	# Need to be improved
	TranslationService.translate_node_recursively(self)
	get_dir_files(DialogResources.RESOURCES_DIR)
	if tree.get_root().get_text(0) == "":
		tree.get_root().set_text(0, DialogResources.RESOURCES_DIR)

func load_items() -> void:
	var _files:Array = DialogDB.DialogFiles.get_files()
	var _items = []
	for file in _files:
		_items.append({file:null})
#	$TimelineListPopUp.items = _items

func get_resource_type(path: String) -> String:
	var result = ""
	var itemName = path.split("/")[-1].split(".")[0]
	if DialogDB.Characters.get_character(itemName):
		result = "character"
	if DialogDB.Timelines.get_timeline(itemName):
		result = "timeline"
	return result

func get_dir_files(path: String, parent: TreeItem=null) -> void:
	var dir := Directory.new()
	dir.open(path)
	var pathArray = path.rsplit("/", true, 0)

	if dir.file_exists(path):
		var currentFile = tree.create_item(parent)
		var type = get_resource_type(path)
		currentFile.set_text(0, pathArray[-1])
		match type:
			"character":
				currentFile.set_icon(0, characterIcon)
			"timeline":
				currentFile.set_icon(0, timelineIcon)
		currentFile.set_metadata(0, [type, pathArray[-1]])
	else:
		var currentFolder
		if parent != null and parent.get_text(0) == pathArray[-2]:
			currentFolder = tree.create_item(parent)
		else:
			currentFolder = tree.create_item()
		currentFolder.set_text(0, pathArray[-1])
		currentFolder.set_icon(0, get_icon("Folder", "EditorIcons"))
		dir.list_dir_begin(true,  true)
		while(true):
			var subpath := dir.get_next()
			if subpath.empty():
				break
			get_dir_files(path.plus_file(subpath), currentFolder)

func _on_ToolBar_character_selected(character) -> void:
	if _editor_view:
		_editor_view.queue_free()
	_editor_view = CharacterEditorScene.instance()
	_editor_view.base_resource = character
	$ViewContainer/HBoxContainer.add_child(_editor_view)



func _on_ToolBar_timeline_selected(timeline) -> void:
	if _editor_view:
		_editor_view.queue_free()
	_editor_view = TimelineEditorScene.instance()
	_editor_view.base_resource = timeline
	$ViewContainer/HBoxContainer.add_child(_editor_view)

func _on_file_selected(file) -> void:
	if _editor_view:
		_editor_view.queue_free()
	_editor_view = TimelineEditorScene.instance()
	_editor_view.base_resource = file
	$ViewContainer/HBoxContainer.add_child(_editor_view)

func _exit_tree() -> void:
	if _editor_view and is_instance_valid(_editor_view):
		_editor_view.free()


func _on_Tree_item_activated():
	var itemName = tree.get_selected().get_metadata(0)[1].split(".")[0]
	var type = tree.get_selected().get_metadata(0)[0]
	if type == "character":
		_on_ToolBar_character_selected(DialogDB.Characters.get_character(itemName))
	if type == "timeline":
		_on_ToolBar_timeline_selected(DialogDB.Timelines.get_timeline(itemName))
