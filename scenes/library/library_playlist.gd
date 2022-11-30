extends VBoxContainer

# Signals
signal item_pressed(music_playlist)
signal deleted

# Nodes
onready var CoverArt := $Header/VBox/CoverArt/Image
onready var TitleEdit := $Header/VBox/VBox/LabelEdit 
onready var TitleLabel := $Header/VBox/Label
onready var List := $List
onready var DeleteBtn := $Header/VBox/Delete
onready var LabelEditVBox := $Header/VBox/VBox
onready var CoverArtDialog := $Header/VBox/CoverArt/CoverArtDialog
onready var SearchEdit := $Labels/HBox/Title/SearchEdit
onready var LabelTitle := $Labels/HBox/Title/Label

# Private
var _music_item_scene = preload("res://scenes/library/MusicItem.tscn")
var _title_node # either TitleEdit or TitleLabel, refer to editable()
var _current_playlist_playing : MusicPlaylist

# Public
var category : LibraryCategory
var music_card : MusicCard
var music_playlist : MusicPlaylist
var music_item_group : MusicItemGroup


func _ready():
	CoverArtDialog.filters = Defaults.image_filter
	hide()


func fill(new_music_card:MusicCard, new_category:LibraryCategory):
	save_edit()
	category = new_category
	music_card = new_music_card
	var editable = music_card.editable
	editable(editable)
	if music_playlist != null and music_playlist == new_music_card.playlist:
		return # escapes function
	
	music_item_group = MusicItemGroup.new()
	if new_music_card.playlist == _current_playlist_playing:
		music_item_group.preset(new_music_card.playlist.get_current())
		
	music_playlist = new_music_card.playlist
	# warning-ignore:return_value_discarded
	if !music_playlist.is_connected("current_changed", self, "_on_Playlist_current_changed"):
		music_playlist.connect("current_changed", self, "_on_Playlist_current_changed")

	CoverArt.texture = music_playlist.cover_art
	_title_node.text = music_playlist.title
	clear()
	for music in music_playlist.list:
		add_item(music, editable)

func clear():
	for child in List.get_children():
		List.remove_child(child)
		child.queue_free()


func add_item(music:Music, editable:bool):
	var item = _music_item_scene.instance()
	item.set_music(music)
	item.set_editable(editable)
	item.connect("pressed", self, "_on_MusicItem_pressed")
	item.connect("remove_pressed", self, "_on_MusicItem_remove_pressed")
	item.connect("repositioned", self, "_on_MusicItem_repositioned")
	List.add_child(item)
	music_item_group.add(item)


func save_edit():
	if music_playlist != null and !music_playlist.file_path.empty():
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


func _on_Search_pressed():
	LabelTitle.hide()
	SearchEdit.show()
	SearchEdit.grab_focus()

func _on_SearchEdit_text_changed(new_text):
	music_item_group.show(new_text)

func _on_SearchEdit_focus_exited():
	LabelTitle.show()
	SearchEdit.hide()
	music_item_group.show_all()


func _on_MusicItem_pressed(music_item):
	if music_playlist != null:
		GlobalLibrary.current_playlist_card = music_card
		_current_playlist_playing = music_playlist
		music_playlist.set_current(music_playlist.get_position(music_item.music))
		emit_signal("item_pressed", music_playlist)

func _on_MusicItem_repositioned(music, index):
	music_playlist.set_position(music, index)

func _on_MusicItem_remove_pressed(music):
	music_playlist.remove(music)


func _on_Playlist_current_changed(music):
	music_item_group.select_by_music(music)


func _on_LabelEdit_title_changed(new_text):
	music_playlist.set_title(new_text)
	music_card.set_title(new_text)

func _on_CoverArt_Edit_pressed():
	CoverArtDialog.show()


func _on_Delete_pressed():
	category.remove_child(music_card)
	ShortLib.remove_file(music_playlist.file_path, false, true)
	music_playlist = null
	music_card = null
	clear()
	emit_signal("deleted")


func _on_CoverArtDialog_files_selected(files):
	if !files.empty():
		music_playlist.set_cover_art(files[0])
		CoverArt.texture = music_playlist.get_cover_art()
		music_card.set_cover_art(music_playlist.get_cover_art())


func _exit_tree():
	save_edit()
