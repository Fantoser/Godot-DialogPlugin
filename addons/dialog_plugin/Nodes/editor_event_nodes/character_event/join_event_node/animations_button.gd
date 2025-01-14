tool
extends OptionButton

func _ready() -> void:
	_add_items()

func _clear_items() -> void:
	for _item_idx in range(get_item_count()-1):
		var _idx = clamp(_item_idx-1, 0, get_item_count()-1)
		remove_item(_idx)

func _add_items() -> void:
	_clear_items()
	var idx = 0
	for key in DialogPortraitManager.PAnimation:
		add_item(key.capitalize())
		set_item_metadata(idx, DialogPortraitManager.PAnimation[key])
		idx += 1
