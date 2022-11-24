extends PanelContainer

# Signals
signal pressed(music)

# Nodes
onready var CoverArt := $HBox/CoverArt
onready var Title := $HBox/Info/Title
onready var Artist := $HBox/Info/Artist
onready var Length := $HBox/Info/Length

# Public
var music : Music

func set_music(new_music:Music):
	music = new_music
	if CoverArt == null:
		CoverArt = get_node("HBox/CoverArt")
	if Title == null:
		Title = get_node("HBox/Info/Title")
	if Artist == null:
		Artist = get_node("HBox/Info/Artist")
	if Length == null:
		Length = get_node("HBox/Info/Length")
	CoverArt.texture = music.metadata.get_artworks()[0]
	Artist.text = str(music.metadata.get_artists())
	Title.text = music.metadata.get_title()
	Length.text = ShortLib.time_convert(music.length) 

func get_music() -> Music:
	return music


func _gui_input(event):
	if event.is_action_pressed("mouse_left"):
		if music != null:
			emit_signal("pressed", music)
