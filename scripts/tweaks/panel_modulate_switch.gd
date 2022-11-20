tool
extends Panel


export var primary_color := Color.white setget set_primary_color, get_primary_color
export var secondary_color := Color.white setget set_secondary_color, get_secondary_color
export var ignore_self := false


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	connect("mouse_entered", self, "_mouse_entered")
	# warning-ignore:return_value_discarded
	connect("mouse_exited", self, "_mouse_exited")
	set_process_input(ignore_self)


func _input(event): 
	if event is InputEventMouse:
		var panel_rect = Rect2(rect_global_position, rect_size)
		var mouse_rect = Rect2(get_global_mouse_position(), Vector2(1.5,1.5))
		if panel_rect.intersects(mouse_rect):
			get_stylebox("panel").bg_color = secondary_color
		else:
			get_stylebox("panel").bg_color = primary_color
		

func set_primary_color(color:Color):
	primary_color = color
	get_stylebox("panel").bg_color = color

func get_primary_color() -> Color:
	return primary_color


func set_secondary_color(color:Color):
	secondary_color = color

func get_secondary_color() -> Color:
	return secondary_color


func _mouse_entered():
	get_stylebox("panel").bg_color = secondary_color

func _mouse_exited():
	get_stylebox("panel").bg_color = primary_color
	
