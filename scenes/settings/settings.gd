extends PanelContainer
class_name ContentSettings

# Nodes
onready var Directories := $Content/Left/Directories as SettingsDirectories

# Public
var playlist_dir := Defaults.get_playlist_dir()
var chords_dir := Defaults.get_chords_dir()


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	var dir = Directory.new()
	var config_file = Defaults.get_settings_config_file()
	if !dir.dir_exists(playlist_dir):
		dir.make_dir(playlist_dir)
	if !dir.dir_exists(chords_dir):
		dir.make_dir(chords_dir)
	if !file.file_exists(config_file):
		save_data()
	load_data()
	Directories.scan_music()


func save_data():
	var file = File.new()
	var data = {}
	data["directories"] = Directories.get_data()
	file.open(Defaults.get_settings_config_file(), File.WRITE)
	file.store_string(JSON.print(data, "\t"))
	file.close()

func load_data():
	var file = File.new()
	file.open(Defaults.get_settings_config_file(), File.READ)
	var data = parse_json(file.get_as_text())
	Directories.set_data(data.get("directories", {}))
	file.close()


func _exit_tree():
	save_data()
