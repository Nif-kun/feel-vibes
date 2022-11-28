extends PanelContainer

# Nodes
onready var MusicPlayer := $"%MusicPlayer"
onready var Content := $VLayout/HSplitLayout/Content as MainContent
onready var Layout := $VLayout
onready var Loading := $Loading


# Called when the node enters the scene tree for the first time.
func _ready():
	Layout.hide()
	Loading.show()
	# warning-ignore:return_value_discarded
	Content.Settings.Directories.connect("music_collected", self, "_on_Directories_music_collected")
	yield(Content.Library, "setup_complete")
	var tween = create_tween()
	tween.tween_property(Loading, "modulate", Color("00ffffff"), 0.5)
	yield(tween, "finished")
	remove_child(Loading)
	Loading.queue_free()
	Layout.show()


func _on_Directories_music_collected(music_list):
	Content.Library.setup(music_list)


func _on_Library_pressed():
	Content.show_library()

func _on_Design_pressed():
	assert(get_tree().change_scene(Defaults.EditorScene) == OK, "FeelVibes[ERR]: Failed  to load editor!")

func _on_Settings_pressed():
	Content.show_settings()


func _on_MusicPlayer_pressed_lyrics():
	Content.show_lyrics()

func _on_MusicPlayer_pressed_artwork():
	Content.show_artwork()


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
		Content.Lyrics.set_text(lyrics)
	else:
		Content.Lyrics.set_text("No lyrics...")

func _on_Library_music_selected(music_playlist):
	print(music_playlist.get_current().metadata.get_title())
	MusicPlayer.set_playlist(music_playlist)


func _on_Artwork_file_selected(file_path):
	MusicPlayer.get_playlist().get_current().metadata.set_comment(file_path)
