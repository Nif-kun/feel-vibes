extends PanelContainer

# Nodes
onready var MusicPlayer := $"%MusicPlayer"

# Public
var music := AudioCollection.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	music.connect("progress", self, "_progress")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_FileInspector_dir_selected(path):
	print("path: ", path)
	music.open(path, 5, true, ["mp3", "ogg", "wav"], true)
	var playlist = MusicPlaylist.new("ALL", music.list)
	MusicPlayer.set_playlist(playlist)


func _progress(value):
	print("progress: ", value)
