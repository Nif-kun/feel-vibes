tool
extends SwitchIconButton
class_name SwitchIconModulateMenuButton

# Public
export var primary_color := Color.white setget set_primary_color, get_primary_color
export var secondary_color := Color.white setget set_secondary_color, get_secondary_color


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
	._on_toggled(button_pressed)
	if button_pressed:
		self_modulate = secondary_color
	else:
		self_modulate = primary_color

func _on_mouse_entered():
	._on_mouse_entered()
	self_modulate = secondary_color

func _on_mouse_exited():
	._on_mouse_exited()
	if !on_toggle:
		self_modulate = primary_color
	elif !pressed:
		self_modulate = primary_color

func _on_focus_entered():
	._on_focus_entered()
	self_modulate = secondary_color

func _on_focus_exited():
	._on_focus_exited()
	if !on_toggle:
		self_modulate = primary_color
	elif !pressed:
		self_modulate = primary_color
