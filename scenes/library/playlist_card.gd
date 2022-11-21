extends PanelContainer
class_name PlaylistCard

signal pressed

# Nodes
onready var BGPanel := $VBox/PanelContainer/Panel
onready var Cover := $VBox/CoverArt/Image
onready var Title := $VBox/Title/Label

# Exports
export var primary_color := Color("181818")
export var secondary_color := Color("272727")

# Public
var music_playlist : MusicPlaylist


func set_playlist(playlist:MusicPlaylist):
	music_playlist = playlist
	Title.text = playlist.title
	Cover.texture = playlist.cover_art

func get_playlist() -> MusicPlaylist:
	return music_playlist


func _gui_input(event):
	if event.is_action_pressed("mouse_left"):
		emit_signal("pressed")


func _on_PlaylistCard_mouse_entered():
	BGPanel.self_modulate = Color("9fffffff")
	self_modulate = secondary_color


func _on_PlaylistCard_mouse_exited():
	BGPanel.self_modulate = Color("ffffff")
	self_modulate = primary_color
