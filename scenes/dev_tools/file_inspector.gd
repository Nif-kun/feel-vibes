extends CanvasLayer

signal file_selected(path)


func _on_Button_pressed():
	$FileDialog.popup()


func _on_FileDialog_file_selected(path):
	emit_signal("file_selected", path)
