extends Node

var chords_collection : Dictionary

func _ready():
	var file = File.new()
	if file.file_exists(Defaults.get_chords_config_file()):
		file.open(Defaults.get_chords_config_file(), File.READ)
		var data = parse_json(file.get_as_text())
		if data is Dictionary:
			chords_collection = data
	else:
		file.open(Defaults.get_chords_config_file(), File.WRITE)
		file.store_string("{}")
	file.close()


func save():
	var file = File.new()
	file.open(Defaults.get_chords_config_file(), File.WRITE)
	file.store_string(JSON.print(chords_collection, "\t"))
	file.close()


func _exit_tree():
	save()
