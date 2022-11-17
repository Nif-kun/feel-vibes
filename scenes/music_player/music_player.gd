extends PanelContainer

# Nodes
onready var Music := $AudioStreamPlayer
onready var Volume := $Divider/Extra/Volume
onready var PlayButton := $Divider/Player/Buttons/Play
onready var PlaybackSlider := $Divider/Player/Playback/Progressbar/Playback
onready var CurrentTime := $Divider/Player/Playback/Current
onready var EndTime := $Divider/Player/Playback/End
onready var AlbumArt := $Divider/Song/AlbumArt
onready var Title := $Divider/Song/VBox/Title
onready var Artist := $Divider/Song/VBox/Artist

# CS-objects
var MDReader = Defaults.mdreader_script.new()
var Zipper = Defaults.zipper_script.new()

# Private
var _master_bus := AudioServer.get_bus_index("Master")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(_delta):
	if stepify(Music.get_playback_position(), 0.1) == stepify(Music.stream.get_length(), 0.1):
		Music.stop()
		set_process(false)	
	if Music.playing:
		CurrentTime.text = ShortLib.time_convert(int(Music.get_playback_position()))
		PlaybackSlider.value =  int(Music.get_playback_position())


func set_music(audio:AudioStream):
	Music.set_stream(audio)
	PlaybackSlider.max_value = Music.stream.get_length()
	EndTime.text = ShortLib.time_convert(int(Music.stream.get_length()))


func set_metadata(metadata:MusicMetadata):
	# Highly advised to replace label with RichTextLabel and use BBCode
	# Refer to BBCode and CharFXTransform docs.
	# Animate text when clipping, moves left and right with fade.
	if metadata.get_title() != null:
		Title.text = metadata.get_title()
	if metadata.get_artists() != null:
		Artist.text = metadata.get_artists()[0]
	if metadata.get_artworks() != null:
		AlbumArt.texture = metadata.get_artworks()[0]


func _on_FileInspector_file_selected(path):
	var metadata = MusicMetadata.new(path)
	var audio_loader = AudioLoader.new()
	
	set_music(audio_loader.loadfile(path))
	set_metadata(metadata)


func _on_Play_toggled(button_pressed):
	if button_pressed:
		if Music.get_playback_position() <= 0.0:
			Music.play()
		if Music.stream_paused:
			Music.stream_paused = false
		set_process(true)
	else:
		Music.stream_paused = true
		set_process(false)


func _on_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(_master_bus, value)
	if value == -45:
		AudioServer.set_bus_mute(_master_bus, true)
	else:
		AudioServer.set_bus_mute(_master_bus, false)


func _on_Playback_drag_started():
	Music.stream_paused = true
	set_process(false)


func _on_Playback_drag_ended(_value_changed):
	if PlayButton.pressed:
		Music.stream_paused = false
		set_process(true)


func _on_Playback_value_changed(value):
	Music.seek(value)
	if !is_processing():
		CurrentTime.text = ShortLib.time_convert(int(Music.get_playback_position()))
