class_name Defaults

# Directories
const _temp_dir := "temp"
const config_file := "fvd_config.json"
const project_extension := ".fvd"

static func get_base_dir() -> String:
	return OS.get_user_data_dir()

static func get_temp_dir() -> String:
	return OS.get_user_data_dir()+"/"+_temp_dir


# Assets
const stock_icon = preload("res://assets/icons/material_ui/white_48dp/palette_white_48dp.svg")
const volume_full = preload("res://assets/icons/material_ui/white_48dp/volume_up_white_48dp.svg")
const volume_half = preload("res://assets/icons/material_ui/white_48dp/volume_down_white_48dp.svg")
const volume_empty = preload("res://assets/icons/material_ui/white_48dp/volume_mute_white_24dp.svg")

# CS.Scripts
const zipper_script = preload("res://library/Zipper.cs")
const mdreader_script = preload("res://library/MDReader.cs")

# Spotify green: 28c760 button, 28b359 Slider ver
