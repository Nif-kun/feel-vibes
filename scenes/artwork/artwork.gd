extends PanelContainer

# CS.Objects
onready var Zipper := Defaults.zipper_script.new()

# Nodes
onready var BgColor := $BgColor
onready var BgTexture := $BgTexture
onready var AtlasPlayer := $AtlasPlayer

# Paths
var temp_dir := Defaults.get_temp_dir()
var config_file := Defaults.config_file
var project_extension := Defaults.project_extension

# Exports
export var _default_bg_color := Color("00ffffff")
export var _auto_start := false


func _ready():
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


func set_animation(save_file):
	var texture_images = Zipper.CollectTextureImages(save_file)
	var config_json = JSON.parse(Zipper.ReadTextFile(save_file, config_file)).result
	BgColor.color = Color(config_json["background"]["color"])
	BgTexture.texture = texture_images[config_json["background"]["texture"]]
	AtlasPlayer.set_hframe(config_json["sprite"]["hframe"])
	AtlasPlayer.set_vframe(config_json["sprite"]["vframe"])
	AtlasPlayer.set_start_frame(config_json["sprite"]["start_frame"])
	AtlasPlayer.set_end_frame(config_json["sprite"]["end_frame"])
	AtlasPlayer.set_speed(config_json["sprite"]["speed"])
	AtlasPlayer.set_loop(config_json["sprite"]["loop"])
	AtlasPlayer.set_atlas_texture(texture_images[config_json["sprite"]["texture"]])
	if _auto_start:
		AtlasPlayer.start()


func start():
	AtlasPlayer.start()


func stop():
	AtlasPlayer.stop()
