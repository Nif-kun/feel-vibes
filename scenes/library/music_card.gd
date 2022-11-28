extends PanelContainer
class_name MusicCard

# Signals
signal pressed(music_card)

# Nodes
onready var Title := $VBox/Title/Label
onready var CoverArt := $VBox/CoverArt
onready var Highlight := $Highlight

# Private
var _default_min_height : float
var _rect_loaded := false

# Public
var playlist : MusicPlaylist 
var editable := false


func _ready():
	_default_min_height = rect_min_size.y
	_rect_loaded = true


func set_playlist(new_playlist:MusicPlaylist):
	# Note: onready nodes are not loaded unless added to SceneTree.
	if Title == null:
		Title = get_node("VBox/Title/Label")
	if CoverArt == null:
		CoverArt = get_node("VBox/CoverArt")
	if new_playlist != null:
		Title.text = new_playlist.title
		Title.hint_tooltip = Title.text
		if new_playlist.cover_art == null:
			new_playlist.cover_art = Defaults.image_icon
		CoverArt.texture = new_playlist.cover_art
		playlist = new_playlist

func get_playlist():
	return playlist


func set_title(title:String):
	Title.text = title

func get_title() -> String:
	return Title.text


func set_cover_art(texture:Texture):
	CoverArt.texture = texture

func get_cover_art() -> Texture:
	return CoverArt.texture


func set_editable(flag:bool):
	editable = flag

func get_editable() -> bool:
	return  editable


func _gui_input(event):
	if event.is_action_pressed("mouse_left"):
		emit_signal("pressed", self)
		Highlight.hide()


func _on_MusicCard_mouse_entered():
	Highlight.show()


func _on_MusicCard_mouse_exited():
	Highlight.hide()


func _resized():
	if _rect_loaded:
		rect_min_size.y = _default_min_height + (rect_size.x - rect_min_size.x)


func _exit_tree():
	queue_free()
