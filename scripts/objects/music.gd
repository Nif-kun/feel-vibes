extends MusicObject
class_name Music

var file_path := ""
var audio : AudioStream = AudioStreamSample.new()
var length : float = 0.0
var metadata := MusicMetadata.new()


func _init(path:String=""):
	read(path)


func read(path:String):
	verify(path)
	if valid:
		file_path = path
		var audio_loader = AudioLoader.new()
		metadata = MusicMetadata.new(path)
		audio = audio_loader.loadfile(path)
		length = audio.get_length()
		if length == 0: # this catches corrupted or differently encoded audio files.
			valid = false
