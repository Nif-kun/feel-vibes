extends VBoxContainer

# Signals
signal item_pressed(music_playlist)
signal deleted

# Nodes
onready var CoverArt := $Header/VBox/CoverArt
onready var TitleEdit := $Header/VBox/VBox/LabelEdit 
onready var TitleLabel := $Header/VBox/Label
onready var List := $List
onready var DeleteBtn := $Header/VBox/Delete
onready var LabelEditVBox := $Header/VBox/VBox

# Private
var _music_item_scene = preload("res://scenes/library/MusicItem.tscn")
var _title_node # either TitleEdit or TitleLabel, refer to editable()

# Public
var category : LibraryCategory
var music_card : MusicCard
var music_playlist : MusicPlaylist
var item_list = []


func _ready():
	hide()


func fill(new_music_card:MusicCard, new_category:LibraryCategory):
	if music_playlist != null:
		save_edit()
		
	category = new_category
	music_card = new_music_card
	editable(music_card.editable)
	
	if music_playlist != null and music_playlist == new_music_card.playlist:
		return # escapes function
	
	music_playlist = new_music_card.playlist
	CoverArt.texture = music_playlist.cover_art
	_title_node.text = music_playlist.title
	clear()
	for music in music_playlist.list:
		add_item(music)

func clear():
	item_list.clear()
	for child in List.get_children():
		List.remove_child(child)
		child.queue_free()


func add_item(music:Music):
	var item = _music_item_scene.instance()
	item.set_music(music)
	item.connect("pressed", self, "_on_MusicItem_pressed")
	item_list.append(item)
	List.add_child(item)


func save_edit():
	if !music_playlist.file_path.empty():
		ShortLib.write_text_file(music_playlist.file_path, JSON.print(music_playlist.get_data(), "\t"))


func editable(flag:bool):
	if flag:
		_title_node = TitleEdit
		TitleLabel.hide()
		LabelEditVBox.show()
		DeleteBtn.show()
	else:
		_title_node = TitleLabel
		LabelEditVBox.hide()
		DeleteBtn.hide()
		TitleLabel.show()


func _on_MusicItem_pressed(music):
	if music_playlist != null:
		music_playlist.set_current(music_playlist.get_position(music))
		emit_signal("item_pressed", music_playlist)


func _on_LabelEdit_title_changed(new_text):
	music_playlist.set_title(new_text)


func _on_Delete_pressed():
	category.remove_child(music_card)
	# playlist is still present in MusicCard in card_list > Library_Category
	music_playlist = null
	music_card = null
	item_list.clear()
	clear()
	emit_signal("deleted")
