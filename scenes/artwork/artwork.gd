extends PanelContainer

# Signals
signal file_selected(file_path)

# CS.Objects
onready var Zipper := Defaults.zipper_script.new()

# Nodes
onready var BgColor := $BgColor
onready var BgTexture := $BgTexture
onready var AtlasPlayer := $AtlasPlayer
onready var Info := $Info
onready var OpenDialog := $NativeDialogOpenFile

# Paths
var temp_dir := Defaults.get_temp_dir()
var config_file := Defaults.config_file
var project_extension := Defaults.project_extension

# Exports
export var _default_bg_color := Color("00ffffff")
export var _auto_start := false

# Public
var playing := false
var file_path := ""

func _ready():
	Info.hide()
	BgColor.color = _default_bg_color


func reset():
	BgColor.color = _default_bg_color
	BgTexture.texture = null
	AtlasPlayer.set_atlas_texture(null)
	AtlasPlayer.set_hframe(1)
	AtlasPlayer.set_vframe(1)
	AtlasPlayer.set_start_frame(1)
	AtlasPlayer.set_end_frame(1)
	AtlasPlayer.set_speed(1)
	AtlasPlayer.set_loop(true)
	Info.show()


func set_animation(save_path:String):
	file_path = save_path
	if save_path.to_lower().get_extension() == "fvd":
		Info.hide()
		var texture_images = Zipper.CollectTextureImages(save_path)
		var config_json :Dictionary= JSON.parse(Zipper.ReadTextFile(save_path, config_file)).result
		BgColor.color = Color(config_json["background"]["color"])
		BgTexture.texture = texture_images.get(config_json["background"]["texture"])
		AtlasPlayer.set_hframe(config_json["sprite"]["hframe"])
		AtlasPlayer.set_vframe(config_json["sprite"]["vframe"])
		AtlasPlayer.set_start_frame(config_json["sprite"]["start_frame"])
		AtlasPlayer.set_end_frame(config_json["sprite"]["end_frame"])
		AtlasPlayer.set_speed(config_json["sprite"]["speed"])
		AtlasPlayer.set_loop(config_json["sprite"]["loop"])
		AtlasPlayer.set_atlas_texture(texture_images.get(config_json["sprite"]["texture"]))
		if _auto_start:
			start()
	else:
		reset()


func start():
	AtlasPlayer.start()
	playing = true


func stop():
	AtlasPlayer.stop()
	playing = false


func _on_Select_pressed():
	OpenDialog.filters = ["*.fvd ; FeelVibes Design File"]
	OpenDialog.show()


func _on_NativeDialogOpenFile_files_selected(files):
	if !files.empty():
		set_animation(files[0])
		emit_signal("file_selected", files[0])
