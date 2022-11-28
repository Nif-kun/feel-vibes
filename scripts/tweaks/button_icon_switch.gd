extends StrictFocusButton
class_name SwitchIconButton

#Note: priority is hover enter is > than focus enter and focus exit is > than hover exit

# Public var
export var sub_icon : Texture
export var on_toggle := false
export var on_hover := false
export var on_focus := false
export var start_sub := false

# Private var
var _default_icon : Texture


# Called when the node enters the scene tree for the first time.
func _ready():
	_default_icon = icon
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
	if start_sub:
		icon = sub_icon


func _on_toggled(flag:bool):
	if on_toggle and sub_icon != null:
		if flag and icon != sub_icon:
			icon = sub_icon
		if not flag and icon == sub_icon:
			icon = _default_icon


func _on_mouse_entered():
	if on_hover and sub_icon != null:
		if icon != sub_icon:
			icon = sub_icon


func _on_mouse_exited():
	if on_hover and sub_icon != null:
		if (!on_focus or get_focus_owner() != self) and !pressed:
			if icon == sub_icon:
				icon = _default_icon


func _on_focus_entered():
	if on_focus and sub_icon != null:
		if icon != sub_icon:
			icon = sub_icon


func _on_focus_exited():
	if on_focus and sub_icon != null and !pressed:
		if icon == sub_icon:
			icon = _default_icon
