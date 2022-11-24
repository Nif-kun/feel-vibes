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
	_show_node(Artwork)

func show_lyrics():
	_show_node(Lyrics)

func show_library():
	_show_node(Library)


func _show_node(node):
	if _current_visible == null:
		_current_visible = node
	else:
		_current_visible.hide()
	node.show()
	_current_visible = node
