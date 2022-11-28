tool
extends TextureButton


export var primary_color := Color.white setget set_primary_color, get_primary_color
export var secondary_color := Color.white setget set_secondary_color, get_secondary_color
export var on_toggle := false
export var on_hover := false
export var on_focus := false

# Called when the node enters the scene tree for the first time.
func _ready():
	if on_toggle:
		# warning-ignore:RETURN_VALUE_DISCARDED
		connect("toggled", self, "_on_toggled")
	if on_hover:
		# warning-ignore:RETURN_VALUE_DISCARDED
		connect("mouse_entered", self, "_on_mouse_entered")
		# warning-ignore:RETURN_VALUE_DISCARDED
		connect("mouse_exited", self, "_on_mouse_exited")
	if on_focus:
		# warning-ignore:RETURN_VALUE_DISCARDED
		connect("focus_entered", self, "_on_focus_entered")
		# warning-ignore:RETURN_VALUE_DISCARDED
		connect("focus_exited", self, "_on_focus_exited")


func set_primary_color(color:Color):
	primary_color = color
	self_modulate = color

func get_primary_color() -> Color:
	return primary_color


func set_secondary_color(color:Color):
	secondary_color = color

func get_secondary_color() -> Color:
	return secondary_color


func _on_toggled(button_pressed):
	if button_pressed:
		self_modulate = secondary_color
	else:
		self_modulate = primary_color

func _on_mouse_entered():
	self_modulate = secondary_color

func _on_mouse_exited():
	if !on_toggle and (on_focus and get_focus_owner() != self):
		self_modulate = primary_color
	elif !pressed and (on_focus and get_focus_owner() != self):
		self_modulate = primary_color

func _on_focus_entered():
	self_modulate = secondary_color

func _on_focus_exited():
	if !on_toggle:
		self_modulate = primary_color
	elif !pressed:
		self_modulate = primary_color
