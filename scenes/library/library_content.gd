extends ScrollContainer

# Nodes
onready var Playlist := $PBox/Playlist
onready var PlaylistCards := $PBox/PlaylistCards as LibraryCategory
onready var AlbumCards := $PBox/AlbumCards as LibraryCategory
onready var ArtistCards := $PBox/ArtistsCards as LibraryCategory
onready var PBox := $PBox

# Private
var _current_visible
var _previous_visible

# Public
export var default := "PlaylistCards"


func _ready():
	var children = PBox.get_children()
	for child in children:
		if child.visible:
			if child.name.to_lower() != default.to_lower():
				child.hide()
			else:
				_current_visible = child


func get_current() -> Control:
	return _current_visible

func get_previous() -> Control:
	return _previous_visible


func show_previous():
	_show_node(_previous_visible)

func show_playlist():
	_show_node(Playlist)

func show_playlist_cards():
	_show_node(PlaylistCards)

func show_album_cards():
	_show_node(AlbumCards)

func show_artist_cards():
	_show_node(ArtistCards)


func _show_node(node):
	if _current_visible == null:
		_current_visible = node
	else:
		_previous_visible = _current_visible
		_current_visible.hide()
	node.show()
	_current_visible = node
