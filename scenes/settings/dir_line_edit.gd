extends PanelContainer
tool

# Signals
signal text_validated(flag)

# Nodes
onready var DirLabel := $HBox/Label
onready var DirLineEdit := $HBox/LineEdit
onready var DirFileButton := $HBox/FileButton
onready var DialogSelectFolder := $DialogSelectFolder

# Public
var valid := false
export var label := "Label" setget set_label, get_label
export var color_validity := true
export var invalid_color := Color.red


func set_label(text:String):
	label = text
	get_node("HBox/Label").text = text

func get_label() -> String:
	return label


func set_dir(text:String):
	DirLineEdit.text = text
	DirLineEdit.emit_signal("text_changed", text)

func get_dir() -> String:
	return DirLineEdit.text


func _on_LineEdit_text_changed(new_text):
	if !new_text.empty():
		var dir = Directory.new()
		valid = dir.dir_exists(new_text)
		emit_signal("text_validated", valid)
	if color_validity:
		if valid:
			DirLineEdit.remove_color_override("font_color")
		else:
			DirLineEdit.add_color_override("font_color", invalid_color)

func _on_FileButton_pressed():
	DialogSelectFolder.show()


func _on_DialogSelectFolder_folder_selected(folder):
	if !folder.empty():
		DirLineEdit.text = folder
		DirLineEdit.emit_signal("text_changed", folder)
