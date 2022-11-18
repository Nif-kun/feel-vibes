extends CanvasLayer

signal file_selected(path)

export var current_dir := "" setget set_current_dir

func _on_Button_pressed():
	$FileDialog.popup()


func _on_FileDialog_file_selected(path):
	emit_signal("file_selected", path)

func set_current_dir(path:String):
	if path.empty():
		current_dir = OS.get_user_data_dir()
	else:
		current_dir = path
	$FileDialog.set_current_dir(current_dir)
