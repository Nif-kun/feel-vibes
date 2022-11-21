extends PanelContainer

# Nodes
onready var Artwork := $Artwork
onready var Lyrics := $Lyrics
onready var Library := $Library

# Private
var _current_visible


func _ready():
	var children = get_children()
	for child in children:
		if child.visible:
			child.hide()


func show_artwork():
	if _current_visible == null:
		_current_visible = Artwork
	else:
		_current_visible.hide()
	Artwork.show()
	_current_visible = Artwork


func show_lyrics():
	if _current_visible == null:
		_current_visible = Lyrics
	else:
		_current_visible.hide()
	Lyrics.show()
	_current_visible = Lyrics


func show_library():
	if _current_visible == null:
		_current_visible = Library
	else:
		_current_visible.hide()
	Library.show()
	_current_visible = Library
