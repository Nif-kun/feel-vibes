extends FileCollection
class_name JSONCollection

# Signals
signal progress(value)
# warning-ignore:unused_signal
signal loaded(json)
signal json_collected(list)


func _init(dir_path:String="", limit:=5, skip_hidden:=false, filters:=[], multithread:=true):
	if !dir_path.empty():
		open(dir_path, limit, skip_hidden, filters, multithread)


# Opens the directory and saves all audio file paths to the list variable.
func open(dir_path:String, limit:=5, skip_hidden:=false, filters:=[], multithread:=true):
	if !dir_path.empty():
		.open(dir_path, limit, skip_hidden, filters, multithread)
		if multithread:
			yield(self, "thread_finished")
			var err = _thread.start(self, "_collect_json", true)
			renew_thread(false)
			if err != OK:
				push_error("FileCollection[ERR]: an error occured while starting the thread. ERR_CODE: "+str(err))
			return # escapes function
		_collect_json(false)


func _collect_json(multithread:bool):
	var temp_list = []
	var list_size = list.size() - 1
	var progress = 0
	for file_path in list:
		var file = File.new()
		
		file.open(file_path, File.READ)
		var data = parse_json(file.get_as_text()) # can produce non-interruptive error
		if data is Dictionary or data is Array:
			if data is Dictionary:
				data["json_file_path"] = file_path
			temp_list.append(data)
		file.close()
		
		if multithread:
			call_deferred("emit_signal", "progress", range_lerp(progress, 0, list_size, 0, 100))
			call_deferred("emit_signal", "loaded", data)
		else:
			emit_signal("progress", range_lerp(progress, 0, list_size, 0, 100))
		progress += 1
	list = temp_list # replaces list
	if multithread:
		call_deferred("emit_signal", "json_collected", list)
		call_deferred("emit_signal", "thread_finished")
	else:
		emit_signal("json_collected", list)
