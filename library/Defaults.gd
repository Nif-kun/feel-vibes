class_name Defaults

# Directories
const _temp_dir := "temp"
const _chords_dir := "chords"
const _playlist_dir := "playlist"
const settings_config_file := "settings.cfg"
const chords_config_file := "chords.cfg"
const fvd_config_file := "fvd_config.json"
const project_extension := ".fvd"
const playlist_extension := ".fvp"
const chords_extension := ".fvc"


static func get_base_dir() -> String:
	return OS.get_user_data_dir()

static func get_temp_dir() -> String:
	return OS.get_user_data_dir()+"/"+_temp_dir

static func get_playlist_dir() -> String:
	return OS.get_user_data_dir()+"/"+_playlist_dir

static func get_chords_dir() -> String:
	return OS.get_user_data_dir()+"/"+_chords_dir

static func get_chords_config_file() -> String:
	return OS.get_user_data_dir()+"/"+chords_config_file

static func get_settings_config_file() -> String:
	return OS.get_user_data_dir()+"/"+settings_config_file


# Scene Path
const EditorScene = "res://scenes/editor/Editor.tscn"
const FeelVibes = "res://scenes/FeelVibes.tscn"

# Filters
const image_filter = ["*.png, *.jpg, *.jpeg, *.svg ; Supported Images", "*.jpg ; JPG Images", "*.jpeg ; JPEG Images", "*.png ; PNG Images", "*.svg ; SVG Images"]

# Assets
const stock_icon = preload("res://assets/icons/material_ui/white_48dp/palette_white_48dp.svg")
const volume_full = preload("res://assets/icons/material_ui/white_48dp/volume_up_white_48dp.svg")
const volume_half = preload("res://assets/icons/material_ui/white_48dp/volume_down_white_48dp.svg")
const volume_empty = preload("res://assets/icons/material_ui/white_48dp/volume_mute_white_24dp.svg")
const folder_icon = preload("res://assets/icons/material_ui/white_48dp/folder_open_white_48dp.svg")
const image_icon = preload("res://assets/icons/material_ui/white_48dp/image_white_48dp.svg")

# CS.Scripts
const zipper_script = preload("res://library/Zipper.cs")
const mdreader_script = preload("res://library/MDReader.cs")

# Spotify green: 28c760 button, 28b359 Slider ver
