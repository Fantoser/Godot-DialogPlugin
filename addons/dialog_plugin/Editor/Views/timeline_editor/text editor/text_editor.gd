tool
extends ConfirmationDialog

signal Cancel_called()

onready var textEvent_node

func _ready():
	self.get_close_button().visible = false
	self.get_cancel().visible = false
	self.get_ok().visible = false
	self.get_ok().get_parent().get_parent().visible = false
	$AcceptDialog.add_button("Don't save", false, "NoSave")
	$AcceptDialog.add_button("Save", false, "Save")
#	$AcceptDialog.add_button("Cancel", false, "Cancel")
#	$AcceptDialog.connect("Cancel", self, "_on_acceptDialog_Cancel_pressed")
#	$AcceptDialog.get_ok().connect("pressed", self, "_on_acceptDialog_cancel_pressed")
	$AcceptDialog.get_ok().text = "Cancel"
	$VBoxContainer/HBoxContainer3/Save.set_disabled(true)

#func _process(delta):
#	pass


func _on_Cancel_pressed():
	if $VBoxContainer/TextEdit.text != textEvent_node.text_edit_node.text:
		$AcceptDialog.popup_centered_ratio(0.08)
	else:
		emit_signal("Cancel_called")

func set_text(event_node):
	textEvent_node = event_node
	$VBoxContainer/TextEdit.text = event_node.text_edit_node.text


func _on_Save_pressed():
	textEvent_node.text_edit_node.text = $VBoxContainer/TextEdit.text
	textEvent_node._on_TextEdit_text_changed()
	textEvent_node._save_resource()
	$VBoxContainer/HBoxContainer3/Save.set_disabled(true)

func _on_acceptDialog_save_pressed():
	_on_Save_pressed()
	emit_signal("Cancel_called")

func _on_AcceptDialog_custom_action(action):
	$AcceptDialog.hide()
	match action:
		"Save":
			_on_Save_pressed()
			emit_signal("Cancel_called")
		"NoSave":
			emit_signal("Cancel_called")


func _on_TextEdit_text_changed():
	$VBoxContainer/HBoxContainer3/Save.set_disabled($VBoxContainer/TextEdit.text == textEvent_node.text_edit_node.text)
