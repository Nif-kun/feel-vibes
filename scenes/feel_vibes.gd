extends PanelContainer

# Nodes
onready var MusicPlayer := $"%MusicPlayer"
onready var Artwork := $VLayout/HSplitLayout/Content/Artwork
onready var Lyrics := $VLayout/HSplitLayout/Content/Lyrics
onready var ContentBox := $VLayout/HSplitLayout/Content

# Public
var music_collection := AudioCollection.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	music_collection.connect("audio_collected", self, "_collected")


#----DEV--TOOL--USE----#
func _on_FileInspector_dir_selected(path):
	music_collection.open(path, 5, true, ["mp3", "ogg", "wav"])

func _on_FileInspector2_file_selected(path):
	var file_path = MusicPlayer.get_playlist().get_current().file_path
	MusicPlayer.get_playlist().get_current().metadata.set_comment(path)

func _on_Button_pressed():
	print(MusicPlayer.get_playlist().get_current().metadata.get_comment())
#----DEV--TOOL--USE----#


func _collected(value):
	var local_files_playlist = MusicPlaylist.new("Local Files", [])
	local_files_playlist.list.append(value)


func _on_Library_pressed():
	ContentBox.show_library()


func _on_MusicPlayer_pressed_lyrics():
	ContentBox.show_lyrics()


func _on_MusicPlayer_pressed_artwork():
	ContentBox.show_artwork()


func _on_MusicPlayer_music_selected(music):
	var comment = music.metadata.get_comment()
	var lyrics = music.metadata.get_lyrics()
	if comment.to_lower().get_extension() == "fvd":
		Artwork.set_animation(comment)
	else:
		Artwork.reset()
	if !lyrics.empty():
		Lyrics.set_text(lyrics)
	else:
		Lyrics.set_text("No lyrics...")


func _on_Artwork_file_selected(file_path):
	MusicPlayer.get_playlist().get_current().metadata.set_comment(file_path)
