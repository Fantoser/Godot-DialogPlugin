tool
extends TextEdit


func _ready():
	pass # Replace with function body.


#func _process(delta):
#	pass

func insert_tag(tag_open, tag_close):
	var select_text = ""
	if is_selection_active():
		select_text = get_selection_text()
	insert_text_at_cursor(tag_open + select_text + tag_close)
	cursor_set_column(cursor_get_column()-tag_close.length())

func _on_Bold_pressed():
	insert_tag("[b]", "[/b]")

func _on_Italic_pressed():
	insert_tag("[i]", "[/i]")

func _on_Underscore_pressed():
	insert_tag("[u]", "[/u]")

func _on_Rainbow_pressed():
	insert_tag("[rainbow]", "[/rainbow]")
