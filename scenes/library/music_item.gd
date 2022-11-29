extends PanelContainer
class_name MusicItem

# Signals
signal pressed(music_item)
signal remove_pressed(music)
signal repositioned(music, index)

# Nodes
onready var CoverArt := $HBox/CoverArt
onready var Title := $HBox/Info/Title/Label
onready var Artist := $HBox/Info/Artist/Label
onready var Length := $HBox/Info/Length
onready var Highlight := $Highlight
onready var AddPlaylistBtn := $HBox/AddPlaylist
onready var RemoveBtn := $HBox/RemovePlaylist

# Private
var _hovering_sub_btns := false
var _is_dragging := false

# Public
var music : Music
var selected := false
var editable := false


func _ready():
	AddPlaylistBtn.get_popup().connect("id_pressed", self, "_on_Playlist_pressed")
	for playlist in GlobalLibrary.get_custom_playlists():
		AddPlaylistBtn.get_popup().add_item(playlist.title)
	Highlight.hide()
	RemoveBtn.visible = editable


func set_music(new_music:Music):
	music = new_music
	if CoverArt == null:
		CoverArt = get_node("HBox/CoverArt")
	if Title == null:
		Title = get_node("HBox/Info/Title/Label")
	if Artist == null:
		Artist = get_node("HBox/Info/Artist/Label")
	if Length == null:
		Length = get_node("HBox/Info/Length")
	if !music.metadata.get_artists().empty():
		Artist.text = str(music.metadata.get_artists()).trim_prefix("[").trim_suffix("]")
	else:
		Artist.text = "Unknown"
	CoverArt.texture = music.metadata.get_artworks()[0]
	Artist.hint_tooltip = Artist.text
	Title.text = music.metadata.get_title()
	Title.hint_tooltip = Title.text
	Length.text = ShortLib.time_convert(music.length) 

func get_music() -> Music:
	return music


func select():
	Highlight.show()
	selected = true

func unselect():
	Highlight.hide()
	selected = false


func set_editable(flag:bool):
	editable = flag
	get_node("HBox/RemovePlaylist").visible = flag
	get_node("HBox/Drag").visible = flag

func get_editable() -> bool:
	return editable


func get_title() -> String:
	return Title.text

func get_artists() -> String:
	return Artist.text

func get_length() -> String:
	return Length.text

# I'm too tired to care that I'm so close to killing myself.
# So fuck you if you think this isn't clean as my previous work. It isn't. I'm done.
# Fuck everyone, fuck life, and FUCK EVERYTHING!
func _input(_event):
	if GlobalLibrary.dragging_item:
		if get_global_rect().intersects(Rect2(get_global_mouse_position(), Vector2(1,1))):
			if rect_global_position.y + (rect_size.y / 2) > get_global_mouse_position().y:
				if GlobalLibrary.drag_pos_highlight != null:
					if get_parent().is_a_parent_of(GlobalLibrary.drag_pos_highlight):
						get_parent().remove_child(GlobalLibrary.drag_pos_highlight)
					if get_position_in_parent() > 0:
						get_parent().add_child_below_node(get_parent().get_child(get_position_in_parent()-1), GlobalLibrary.drag_pos_highlight)
					elif get_position_in_parent() == 0:
						GlobalLibrary.drag_pos_highlight.hide()
						get_parent().add_child(GlobalLibrary.drag_pos_highlight)
						get_parent().move_child(GlobalLibrary.drag_pos_highlight, 0)
						GlobalLibrary.drag_pos_highlight.show()
			elif GlobalLibrary.drag_pos_highlight != null:
				if get_parent().is_a_parent_of(GlobalLibrary.drag_pos_highlight):
					get_parent().remove_child(GlobalLibrary.drag_pos_highlight)
				get_parent().add_child_below_node(self, GlobalLibrary.drag_pos_highlight)

func _gui_input(event):
	if event.is_action_pressed("mouse_left") and !_hovering_sub_btns:
		if music != null:
			emit_signal("pressed", self)
			select()

func _on_MusicItem_mouse_entered():
	Highlight.show()

func _on_MusicItem_mouse_exited():
	if !selected:
		Highlight.hide()


func _on_Playlist_pressed(id):
	GlobalLibrary.add_playlist_song(AddPlaylistBtn.get_popup().get_item_text(id), music)

func _on_RemovePlaylist_pressed():
	get_parent().remove_child(self)
	emit_signal("remove_pressed", music)


func _on_SubBtn_mouse_entered():
	_hovering_sub_btns = true

func _on_SubBtn_exited():
	_hovering_sub_btns = false

func _on_Drag_gui_input(event:InputEvent):
	if event.is_action("mouse_left"):
		_is_dragging = !_is_dragging
		GlobalLibrary.dragging_item = _is_dragging
		var drag_pos_highlight = ColorRect.new()
		drag_pos_highlight.rect_min_size.y = 1
		if _is_dragging:
			GlobalLibrary.drag_pos_highlight = drag_pos_highlight
		elif GlobalLibrary.drag_pos_highlight != null:
			get_parent().move_child(self, GlobalLibrary.drag_pos_highlight.get_position_in_parent())
			get_parent().remove_child(GlobalLibrary.drag_pos_highlight)
			GlobalLibrary.drag_pos_highlight.queue_free()
			GlobalLibrary.drag_pos_highlight = null
			emit_signal("repositioned", music, self.get_position_in_parent())


func _exit_tree():
	queue_free()
