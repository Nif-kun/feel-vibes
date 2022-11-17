extends Object
class_name Music

var audio : AudioStream
var length : float
var metadata : MusicMetadata


func _init(path):
	var audio_loader = AudioLoader.new()
	metadata = MusicMetadata.new(path)
	audio = audio_loader.loadfile(path)
	length = audio.get_length()
