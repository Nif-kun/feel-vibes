extends Object
class_name MusicLoader


# Note: MusicLoader only reads two directories deep.
#		This is to avoid significant load times.


func _init(dir_path:String):
	var music_files : PoolStringArray = []
	var dir = Directory.new()
	var open_err = dir.open(dir_path)
	if open_err == OK:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if dir.current_is_dir():
				pass
			else:
				music_files.append(file)
			file = dir.get_next()
	else:
		push_warning("MusicLoader[WRN]: an error occurred when trying to access the path. ERR_CODE: "+str(open_err))
	return music_files


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
