extends PanelContainer

# FIXME Ram overload! Loading audio files than string eats up more ram.
#		This will be a problem in the longrun; A major flaw in the system.
#		A solution is to load them in the MusicPlaylist when get_current() occurs.
#		As of now, fixing this isn't possible to do due to time constraints.
#		This, however, is a good lesson to learn: don't load everything at one.

# Nodes
onready var MusicPlayer := $"%MusicPlayer"
onready var Content := $VLayout/HSplitLayout/Content as MainContent
onready var Layout := $VLayout
onready var Loading := $Loading
onready var Expanded := $Expanded


# Called when the node enters the scene tree for the first time.
func _ready():
	Expanded.hide()
	# warning-ignore:return_value_discarded
	Content.Settings.Directories.connect("music_collected", self, "_on_Directories_music_collected")
	if !Content.Settings.Directories.music_dir_empty:
		Layout.hide()
		Loading.show()
		yield(Content.Library, "setup_complete")
		var tween = create_tween()
		tween.tween_property(Loading, "modulate", Color("00ffffff"), 0.5)
		yield(tween, "finished")
		remove_child(Loading)
		Loading.queue_free()
		Layout.show()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Expanded.hide()


func _on_Directories_music_collected(music_list):
	Content.Library.setup(music_list)


func _on_Library_pressed():
	Content.show_library()

func _on_Design_pressed():
	var err = get_tree().change_scene(Defaults.EditorScene)
	if err != OK:
		print("FeelVibes[ERR]: Failed  to load editor!")

func _on_Settings_pressed():
	Content.show_settings()


func _on_MusicPlayer_played():
	Content.Artwork.start()

func _on_MusicPlayer_paused():
	Content.Artwork.stop()


func _on_MusicPlayer_pressed_lyrics():
	if Content.Lyrics.visible:
		Content.show_previous()
	else:
		Content.show_lyrics()

func _on_MusicPlayer_pressed_artwork():
	if Content.Artwork.visible:
		Content.show_previous()
	else:
		Content.show_artwork()


func _on_Library_music_selected(music_playlist):
	print(music_playlist.get_current().metadata.get_title())
	MusicPlayer.set_playlist(music_playlist)

func _on_MusicPlayer_music_selected(music):
	var comment = music.metadata.get_comment()
	var lyrics = music.metadata.get_lyrics()
	if comment.to_lower().get_extension() == "fvd":
		var dir = Directory.new()
		if dir.file_exists(comment):
			Content.Artwork.set_animation(comment)
	else:
		Content.Artwork.reset()
	if !lyrics.empty():
		Content.Lyrics.set_text(lyrics, music)
	else:
		Content.Lyrics.set_text("No lyrics...", music)


func _on_Artwork_file_selected(file_path):
	MusicPlayer.get_playlist().get_current().metadata.set_comment(file_path)


func _on_Artwork_expand_pressed(control):
	Expanded.show()
	for child in Expanded.get_children():
		if child != get_node("Expanded/HBox"):
			Expanded.remove_child(child)
			child.queue_free()
			
	Expanded.add_child(control.duplicate())


func _on_Minimize_pressed():
	Expanded.hide()
