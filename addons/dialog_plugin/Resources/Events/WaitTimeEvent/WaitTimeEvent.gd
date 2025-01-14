tool
class_name DialogWaitTimeEvent
extends DialogEventResource

export(float, 0, 60, 1) var wait_time = 0.0


func excecute(caller:DialogBaseNode) -> void:
	.excecute(caller)
	yield(caller.get_tree().create_timer(wait_time), "timeout")
	finish()


func get_event_editor_node() -> DialogEditorEventNode:
	var _scene_resource:PackedScene = load("res://addons/dialog_plugin/Nodes/editor_event_nodes/wait_time_event_node/wait_time_event_node.tscn")
	_scene_resource.resource_local_to_scene = true
	var _instance = _scene_resource.instance(PackedScene.GEN_EDIT_STATE_INSTANCE)
	_instance.base_resource = self
	return _instance
