extends FileCollection
class_name AudioCollection

# Signals
signal progress(value)
signal loaded(music)
signal audio_collected(list)


func _init(dir_path:String="", limit:=5, skip_hidden:=false, filters:=[], multithread:=true):
	if !dir_path.empty():
		open(dir_path, limit, skip_hidden, filters, multithread)


func open(dir_path:String, limit:=5, skip_hidden:=false, filters:=[], multithread:=true):
	if !dir_path.empty():
		.open(dir_path, limit, skip_hidden, filters, multithread)
		if multithread:
			yield(self, "file_collected")
			_thread.wait_to_finish()
			_thread = Thread.new()
			_thread.start(self, "_collect_audio", true)
			return # escapes function
		_collect_audio(false)


func _collect_audio(multithread:bool):
	var temp_list = []
	var list_size = list.size() - 1
	var progress = 0
	for file_path in list:
		var music = Music.new(file_path)
		if music.valid:
			temp_list.append(music)
		if multithread:
			call_deferred("emit_signal", "progress", range_lerp(progress, 0, list_size, 0, 100))
			call_deferred("emit_signal", "loaded", music)
		else:
			emit_signal("progress", range_lerp(progress, 0, list_size, 0, 100))
		progress += 1
	list = temp_list # I'm assuming this replaces the list.
	if multithread:
		call_deferred("emit_signal", "audio_collected", list)
	else:
		emit_signal("audio_collected", list)
