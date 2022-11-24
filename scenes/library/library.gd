extends ScrollContainer

# TODO add tabs: Playlist, Album, Artists
# TODO turn All and Local into a playlist instead.
# TODO make repositionable playlist. 
# TODO copy playlist on left side, this is for main window. Add search.

# Nodes
onready var Playlist := $Margin/Categories/Playlist


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(music_list:=[]):
	Playlist.setup(music_list)


func _on_ItemCard_pressed(item):
	if item is MusicPlaylist:
		print(item.title)
