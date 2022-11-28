extends Reference
class_name FileCollection

# Signals
signal file_collected(list)
# warning-ignore:unused_signal
signal thread_finished

# Public
var list := []

# Private
var _thread := Thread.new()
var _renew_thread := true


func _init(dir_path:String="", limit:=5, skip_hidden:=false, filters:=[], multithread:=true):
	if !dir_path.empty():
		open(dir_path, limit, skip_hidden, filters, multithread)
	# warning-ignore:return_value_discarded
	connect("thread_finished", self, "_thread_finished")


# Opens the directory and saves all file paths to the list variable.
func open(dir_path:String, limit:=5, skip_hidden:=false, filters:=[], multithread:=true):
	list.clear()
	if multithread:
		var err = _thread.start(self, "_collect_files_threaded", [dir_path, limit, skip_hidden, filters])
		if err != OK:
			push_error("FileCollection[ERR]: an error occured while starting the thread. ERR_CODE: "+str(err))
	else:
		var dir = Directory.new()
		var err = dir.open(dir_path)
		if err == OK:
			dir.list_dir_begin(true, skip_hidden)
			_collect_files(dir, 0, limit, skip_hidden, filters)
			emit_signal("file_collected", list)


# Ensures safe or unsafe disposal of all objects within self.
func dispose(force:=false):
	list.clear()
	if !force and _thread != null and _thread.is_alive():
		_thread.wait_to_finish()


# Used only when multi-threading.
func renew_thread(value:bool):
	_renew_thread = value


# Format: [dir_path, limit, skip_hidden, filters]
func _collect_files_threaded(state:Array):
	var dir = Directory.new()
	var err = dir.open(state[0])
	if err == OK:
		dir.list_dir_begin(true, state[2])
		_collect_files(dir, 0, state[1], state[2], state[3])
		call_deferred("emit_signal", "file_collected", list)
		call_deferred("emit_signal", "thread_finished")


func _collect_files(dir:Directory, count:int, limit:int, skip_hidden:bool=false, filter:=[]):
	var file_name = dir.get_next()
	while (file_name != "" and count < limit):
		var path = dir.get_current_dir() + "/" + file_name
		if dir.current_is_dir():
			var subDir = Directory.new()
			var err = subDir.open(path)
			if err == OK:
				subDir.list_dir_begin(true, skip_hidden)
				_collect_files(subDir, count+1, limit, skip_hidden, filter)
		elif !filter.empty():
			if filter.has(path.get_extension().to_lower()):
				list.append(path)
		else:
			list.append(path)
		
		file_name = dir.get_next()

	dir.list_dir_end()


func _thread_finished():
	_thread.wait_to_finish()
	if _renew_thread:
		_thread = Thread.new()
	else:
		_thread = null
