extends PanelContainer

# Issues:
# > Selecting another music while it is still playing causes reapet be stuck.

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
export var _default_step := 0.01

# Public
var music : Music
var length := 0.0
var ended := false
var is_lengthy := false


# Called when the node enters the scene tree for the first time.
func _ready():
	PlaybackSlider.step = _default_step
	reset_playback()
	set_process(false)


func _process(_delta):
	if !MusicStreamer.stream_paused:
		var playback_pos_step = stepify(get_time(), 0.1)
		var playback_length_step = stepify(length, 0.1)
		
		CurrentTime.text = ShortLib.time_convert(get_time())
		PlaybackSlider.value = get_time()
		
		ended = playback_pos_step >= playback_length_step
		_set_end_state(ended)


func play():
	MusicStreamer.stream_paused = false
	if !MusicStreamer.playing:
		print("not playing, time to play!")
		var playback_value = PlaybackSlider.value
		var playback_max_value = PlaybackSlider.max_value
		
		if playback_value == playback_max_value:
			playback_value = 0
			ended = false
		if !is_processing():
			print("not processing, time to process!")
			set_process(true)
			
		MusicStreamer.play(playback_value)


func pause():
	MusicStreamer.stream_paused = true


func reset_playback():
	MusicStreamer.stop()
	MusicStreamer.stream_paused = true
	PlaybackSlider.value = 0
	if is_lengthy:
		CurrentTime.text = "00:00:00"
	else:
		CurrentTime.text = "00:00"

#Setget Music
func set_music(new_music:Music):
	music = new_music
	length = new_music.length
	is_lengthy = ShortLib.is_hour(length)
	print("time_in_hour: ", ShortLib.to_hour(length))
	print("is_lengthy: ", is_lengthy)
	reset_playback() # Must be below, func relies on is_lengthy value.
	MusicStreamer.set_stream(music.audio)
	
	# Sets data to widgets
	PlaybackSlider.max_value = length
	EndTime.text = ShortLib.time_convert(length)
	Title.text = new_music.metadata.get_title() # animate overflow text with bbcode
	Artist.text = new_music.metadata.get_artists()[0]
	AlbumArt.set_texture(new_music.metadata.get_artworks()[0]) 
	
	# Starts music
	if PlayButton.pressed:
		play()
	else:
		PlayButton.pressed = true

func get_music() -> Music:
	return music


# Setget Time
func set_time(seconds:float):
	if seconds <= length:
		PlaybackSlider.value = seconds
		MusicStreamer.seek(seconds)
		CurrentTime.text = ShortLib.time_convert(seconds)

func get_time() -> float:
	return MusicStreamer.get_playback_position()


func is_playing() -> bool:
	return MusicStreamer.playing and !MusicStreamer.stream_paused


func _set_end_state(is_end:bool):
	if is_end:
		PlaybackSlider.value = PlaybackSlider.max_value
		CurrentTime.text =  ShortLib.time_convert(length)
		PlayButton.pressed = false
		MusicStreamer.stop()
		set_process(false)
		print("Stopped...")


func _on_FileInspector_file_selected(path):
	var new_music = Music.new(path)
	set_music(new_music)


func _on_Play_toggled(button_pressed):
	if button_pressed:
		play()
	else:
		pause()


func _on_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(_master_bus, value)
	if value == Volume.min_value:
		AudioServer.set_bus_mute(_master_bus, true)
	else:
		AudioServer.set_bus_mute(_master_bus, false)


func _on_Playback_drag_started():
	MusicStreamer.stream_paused = true


func _on_Playback_drag_ended(_value_changed):
	if PlayButton.pressed:
		print("in_drag_end: ", PlaybackSlider.value)
		MusicStreamer.seek(PlaybackSlider.value)
		MusicStreamer.stream_paused = false


func _on_Playback_value_changed(value):
	if is_playing():
		PlaybackSlider.step = 1
		MusicStreamer.seek(PlaybackSlider.value)
		print("in_val_changed: ",value)
		CurrentTime.text = ShortLib.time_convert(value)
	elif PlaybackSlider.step != _default_step:
		PlaybackSlider.step = _default_step
