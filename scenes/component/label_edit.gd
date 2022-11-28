extends HBoxContainer
tool

# Signals
signal text_changed(new_text)

# Nodes
onready var EditBtn := $Button
onready var LabelLine := $LineEdit

# Public
export var text := "" setget set_text, get_text

func _ready():
	EditBtn.hide()


func deprecate():
	LabelLine.set_script(null)
	LabelLine.editable = false
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	remove_child(EditBtn)
	EditBtn.queue_free()


func set_text(new_text:String):
	text = new_text
	get_node("LineEdit").text = text

func get_text() -> String:
	return text


func _on_mouse_entered():
	EditBtn.show()

func _on_mouse_exited():
	EditBtn.hide()


func _on_EditBtn_pressed():
	LabelLine.grab_focus()
	LabelLine.editable = true


func _on_LabelLine_text_changed(new_text):
	text = new_text
	emit_signal("text_changed", new_text)
