extends PanelContainer
class_name MainContent

# Nodes
onready var Library := $Library as ContentLibrary
onready var Lyrics := $Lyrics as ContentLyrics
onready var Artwork := $Artwork as ContentArtwork
onready var Settings := $Settings as ContentSettings

# Private
var _current_visible
var _previous_visible

# Public
export var default := "Library"


func _ready():
	var children = get_children()
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

func show_artwork():
	_show_node(Artwork)

func show_lyrics():
	_show_node(Lyrics)

func show_library():
	_show_node(Library)

func show_settings():
	_show_node(Settings)


func _show_node(node):
	if _current_visible == null:
		_current_visible = node
	else:
		_previous_visible = _current_visible
		_current_visible.hide()
	node.show()
	_current_visible = node
