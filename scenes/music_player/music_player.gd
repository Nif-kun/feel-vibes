extends PanelContainer

# Nodes
onready var MusicStreamer := $AudioStreamPlayer
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
	var playback_pos = stepify(MusicStreamer.get_playback_position(), 0.1)
	var playback_length = stepify(MusicStreamer.stream.get_length(), 0.1)
	if playback_pos == playback_length:
		MusicStreamer.stop()
		set_process(false)
	if MusicStreamer.playing:
		CurrentTime.text = ShortLib.time_convert(int(MusicStreamer.get_playback_position()))
		PlaybackSlider.value =  int(MusicStreamer.get_playback_position())


func set_music(music:Music):
	MusicStreamer.set_stream(music.audio)
	PlaybackSlider.max_value = music.length
	EndTime.text = ShortLib.time_convert(int(music.length))
	
	Title.text = music.metadata.get_title() # animate overflow text with bbcode
	Artist.text = music.metadata.get_artists()[0]
	AlbumArt.set_texture(music.metadata.get_artworks()[0]) 


func _on_FileInspector_file_selected(path):
	var music = Music.new(path)
	set_music(music)


func _on_Play_toggled(button_pressed):
	if button_pressed:
		if MusicStreamer.get_playback_position() <= 0.0:
			MusicStreamer.play()
		if MusicStreamer.stream_paused:
			MusicStreamer.stream_paused = false
		set_process(true)
	else:
		MusicStreamer.stream_paused = true
		set_process(false)


func _on_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(_master_bus, value)
	if value == -45:
		AudioServer.set_bus_mute(_master_bus, true)
	else:
		AudioServer.set_bus_mute(_master_bus, false)


func _on_Playback_drag_started():
	MusicStreamer.stream_paused = true
	set_process(false)


func _on_Playback_value_changed(value):
	MusicStreamer.seek(value)
	if !is_processing():
		CurrentTime.text = ShortLib.time_convert(int(MusicStreamer.get_playback_position()))


func _on_Playback_drag_ended(_value_changed):
	if PlayButton.pressed:
		MusicStreamer.stream_paused = false
		set_process(true)
