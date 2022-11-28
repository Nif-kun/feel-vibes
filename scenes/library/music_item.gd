extends PanelContainer

# Signals
signal pressed(music)

# Nodes
onready var CoverArt := $HBox/CoverArt
onready var Title := $HBox/Info/Title/Label
onready var Artist := $HBox/Info/Artist/Label
onready var Length := $HBox/Info/Length
onready var Highlight := $Highlight

# Public
var music : Music


func _ready():
	Highlight.hide()


func set_music(new_music:Music):
	music = new_music
	if CoverArt == null:
		CoverArt = get_node("HBox/CoverArt")
	if Title == null:
		Title = get_node("HBox/Info/Title/Label")
	if Artist == null:
		Artist = get_node("HBox/Info/Artist/Label")
	if Length == null:
		Length = get_node("HBox/Info/Length")
	if !music.metadata.get_artists().empty():
		Artist.text = str(music.metadata.get_artists()).trim_prefix("[").trim_suffix("]")
	else:
		Artist.text = "Unknown"
	CoverArt.texture = music.metadata.get_artworks()[0]
	Artist.hint_tooltip = Artist.text
	Title.text = music.metadata.get_title()
	Title.hint_tooltip = Title.text
	Length.text = ShortLib.time_convert(music.length) 

func get_music() -> Music:
	return music


func _gui_input(event):
	if event.is_action_pressed("mouse_left"):
		if music != null:
			emit_signal("pressed", music)


func _on_MusicItem_mouse_entered():
	Highlight.show()


func _on_MusicItem_mouse_exited():
	Highlight.hide()


func _exit_tree():
	queue_free()
