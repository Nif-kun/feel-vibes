extends VBoxContainer

# Signals
signal item_pressed(music_playlist)

# Nodes
onready var CoverArt := $Header/VBox/CoverArt
onready var Title := $Header/VBox/Title
onready var List := $List/VBox

# Private
var _music_item_scene = preload("res://scenes/library/MusicItem.tscn")

# Public
var music_playlist : MusicPlaylist
var item_list = []


func set_cover_art(texture:Texture):
	CoverArt.texture = texture

func get_cover_art() -> Texture:
	return CoverArt.texture


func set_title(text:String):
	Title.text = text

func get_title() -> String:
	return Title.text


func fill(playlist:MusicPlaylist):
	music_playlist = playlist
	CoverArt.texture = playlist.cover_art
	Title.text = playlist.title
	
	item_list.clear()
	for child in List.get_children():
		List.remove_child(child)
		child.queue_free()
	
	for music in playlist.list:
		add_item(music)


func add_item(music:Music):
	var item = _music_item_scene.instance()
	item.set_music(music)
	item.connect("pressed", self, "_on_MusicItem_pressed")
	item_list.append(item)
	List.add_child(item)


func _on_MusicItem_pressed(music):
	if music_playlist != null:
		music_playlist.set_current(music_playlist.get_position(music))
		emit_signal("item_pressed", music_playlist)
