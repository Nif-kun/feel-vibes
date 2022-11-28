extends Control

var _prev_focus_owner : Control


# Handles all input events that occur.
func _input(event):
	_remove_focus(event)
	_return_focus(event)


# Removes focus of an object if it is user clicked out of it's bound and not another object.
func _remove_focus(event:InputEvent):
	if event is InputEventMouseButton:
		if event.is_pressed() and get_focus_owner() != null:
			if not get_focus_owner().get_global_rect().intersects(Rect2(get_global_mouse_position(), Vector2(2,2))):
				_prev_focus_owner = get_focus_owner()
				_prev_focus_owner.release_focus()

# On tab press: returns focus to previous owner if non has it.
func _return_focus(event:InputEvent):
	if get_focus_owner() == null:
		if event.is_action_pressed("ui_focus_next"):
			if _prev_focus_owner != null:
				_prev_focus_owner.grab_focus()


