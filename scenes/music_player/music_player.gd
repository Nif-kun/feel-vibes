extends PanelContainer

# IDEA: remember song being played before closing, including timestamp.

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

# Private
var _master_bus := AudioServer.get_bus_index("Master")
var _default_playback_step := 0.01

# Public
var music : Music setget set_music, get_music
var playlist : MusicPlaylist setget set_playlist, get_playlist
var length := 0.0
var repeat := false
var shuffle := false
var ended := false
var is_lengthy := false
export var auto_start := true


# Called when the node enters the scene tree for the first time.
func _ready():
	_default_playback_step = PlaybackSlider.step
	reset_playback()
	set_process(false)


func _process(_delta):
	var playback_pos_step = stepify(get_time(), 0.1)
	var playback_length_step = stepify(length, 0.1)
	
	CurrentTime.text = ShortLib.time_convert(get_time())
	PlaybackSlider.value = get_time()
	
	print(playback_pos_step," - ",playback_length_step)
	_end_state() # occurs once music ends.

func _end_state():
	if !MusicStreamer.playing:
		PlaybackSlider.value = PlaybackSlider.max_value
		CurrentTime.text =  ShortLib.time_convert(length)
		PlayButton.pressed = false
		ended = true
		set_process(false)
		if repeat:
			play()
		else:
			next()


func play():
	# Note: converting to int ensures the [check] below functions properly
	# 		floating points can cause unexpected lower/higher values.
	var playback_value = int(PlaybackSlider.value)
	var playback_max_value = int(PlaybackSlider.max_value)
	
	if playback_value >= playback_max_value: # [check]
		playback_value = 0
	
	if !is_processing():
		set_process(true)
	
	ended = false
	MusicStreamer.stream_paused = false
	MusicStreamer.play(playback_value)
	
	if !PlayButton.pressed: # in last to not re-trigger the toggle event.
		PlayButton.pressed = true

func pause():
	MusicStreamer.stream_paused = true
	set_process(false)

func next():
	if playlist != null and !playlist.list.empty():
		if shuffle:
			playlist.shuffle()
			set_music(playlist.get_current())
		elif playlist.get_current() != playlist.get_next():
			playlist.next() # This is important as it moves the playlist index.
			set_music(playlist.get_current())

func previous():
	if playlist != null and !playlist.list.empty():
		if shuffle:
			playlist.shuffle()
			set_music(playlist.get_current())
		elif playlist.get_current() != playlist.get_previous():
			playlist.previous() # This is important as it moves the playlist index.
			set_music(playlist.get_current())


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
	if new_music != null and new_music.valid:
		music = new_music
		length = new_music.length
		is_lengthy = ShortLib.is_hour(length)
		reset_playback() # Must be below, func relies on is_lengthy value.
		MusicStreamer.set_stream(music.audio)
		
		# Sets data to widgets
		PlaybackSlider.max_value = length
		EndTime.text = ShortLib.time_convert(length)
		# TODO copy spotify move right and left long text.
#		print(get_font("RichTextLabel/fonts/bold_font").font_data.font_path)
		Title.bbcode_text = "[b]"+new_music.metadata.get_title()+"[/b]" # animate overflow text with bbcode
		Artist.bbcode_text = new_music.metadata.get_artists()[0]
		AlbumArt.set_texture(new_music.metadata.get_artworks()[0]) 
		
		# Starts music
		if auto_start:
			play()

func get_music() -> Music:
	return music


func set_playlist(music_playlist:MusicPlaylist):
	if !music_playlist.list.empty():
		playlist = music_playlist
		set_music(playlist.get_current())

func get_playlist() -> MusicPlaylist:
	return playlist


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


func _on_Play_toggled(button_pressed):
	if button_pressed:
		if MusicStreamer.stream_paused or !MusicStreamer.playing:
			play()
	else:
		pause()

func _on_Next_pressed():
	next()

func _on_Previous_pressed():
	previous()


func _on_Playback_drag_started():
	MusicStreamer.stream_paused = true
	set_process(false)


func _on_Playback_drag_ended(_value_changed):
	if PlayButton.pressed:
		MusicStreamer.seek(PlaybackSlider.value)
		MusicStreamer.stream_paused = false
		set_process(true)


func _on_Shuffle_toggled(button_pressed):
	shuffle = button_pressed


func _on_Repeat_toggled(button_pressed):
	repeat = button_pressed


func _on_Playback_value_changed(value):
	if !is_playing():
		PlaybackSlider.step = 1
		MusicStreamer.seek(PlaybackSlider.value)
		CurrentTime.text = ShortLib.time_convert(value)
	elif PlaybackSlider.step != _default_playback_step:
		PlaybackSlider.step = _default_playback_step


func _on_Volume_value_changed(value):
	AudioServer.set_bus_volume_db(_master_bus, value)
	if value == Volume.min_value:
		AudioServer.set_bus_mute(_master_bus, true)
	else:
		AudioServer.set_bus_mute(_master_bus, false)
