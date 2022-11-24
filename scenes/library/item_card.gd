extends PanelContainer
class_name ItemCard

signal pressed(item_card)

# Nodes
onready var BGPanel := $VBox/CoverArt/Panel
onready var Title := $VBox/Title/Label
onready var CoverArt := $VBox/CoverArt/Image

# Exports
export var primary_color := Color("181818")
export var secondary_color := Color("272727")

# Public
var item 


func set_item(title:String, cover_art:Texture, object):
	# Note: onready nodes are not loaded unless added to SceneTree.
	if Title == null:
		Title = get_node("VBox/Title/Label")
	if CoverArt == null:
		CoverArt = get_node("VBox/CoverArt/Image")
	Title.text = title
	CoverArt.texture = cover_art
	item = object

func get_item():
	return item


func _gui_input(event):
	if event.is_action_pressed("mouse_left"):
		emit_signal("pressed", self)


func _on_PlaylistCard_mouse_entered():
	BGPanel.self_modulate = Color("9fffffff")
	self_modulate = secondary_color


func _on_PlaylistCard_mouse_exited():
	BGPanel.self_modulate = Color("ffffff")
	self_modulate = primary_color


func _exit_tree():
	queue_free()
