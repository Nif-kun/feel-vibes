extends ScrollContainer

# TODO add tabs: Playlist, Album, Artists
# TODO turn All and Local into a playlist instead.
# TODO make repositionable playlist. 
# TODO copy playlist on left side, this is for main window. Add search.

# Signals
signal music_selected(music_playlist)

# Nodes
onready var Categories := $Margin/Categories
onready var Playlist := $Margin/Categories/Playlist
onready var Album := $Margin/Categories/Album
onready var Artist := $Margin/Categories/Artist
onready var Content := $Margin/Content


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func setup(music_list:Array):
	Playlist.setup(music_list)
	Album.setup(music_list)
	Artist.setup(music_list)


func _on_ItemCard_pressed(item_card):
	if item_card.item is MusicPlaylist:
		print("should work....")
		Content.fill(item_card.item)
		Categories.hide()
		


func _on_Content_item_pressed(music_playlist):
	emit_signal("music_selected", music_playlist)
