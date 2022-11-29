extends Reference
class_name MusicItemGroup

# Private
var _preset_music : Music

# public
var current_selected : MusicItem
var item_list = []


func add(music_item:MusicItem):
	item_list.append(music_item)
	# warning-ignore:return_value_discarded
	music_item.connect("pressed", self, "_on_MusicItem_pressed")
	if music_item.music == _preset_music:
		current_selected = music_item
		music_item.select()


func preset(music:Music):
	_preset_music = music


func select_by_music(music:Music):
	for music_item in item_list:
		if music_item.music == music:
			if current_selected != null:
				current_selected.unselect()
			current_selected = music_item
			current_selected.select()

func select(music_item:MusicItem):
	var index = item_list.find(music_item)
	if index > -1:
		if current_selected != null:
			current_selected.unselect()
		current_selected = item_list[index]
		current_selected.select()


func show(text:String):
	if !text.empty():
		for item in item_list:
			if text.to_lower() in item.get_title().to_lower():
				item.show()
			else:
				item.hide()
	else:
		show_all()

func show_all():
	for item in item_list:
		item.show()

func hide_all():
	for item in item_list:
		item.hide()


func _on_MusicItem_pressed(music_item):
	if current_selected != music_item:
		if is_instance_valid(current_selected) and current_selected != null:
			current_selected.unselect()
		current_selected = music_item
		current_selected.select()
