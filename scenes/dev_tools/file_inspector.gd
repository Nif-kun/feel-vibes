extends CanvasLayer

signal file_selected(path)
signal files_selected(paths)
signal dir_selected(path)

enum Mode {
	OPEN_FILE = 0,
	OPEN_FILES = 1,
	OPEN_DIR = 2,
	OPEN_ANY = 3,
	SAVE_FILE = 4
}

# Nodes:
onready var _FileDialog := $FileDialog

# Public
export var current_dir := "" 
export(Mode) var mode = Mode.SAVE_FILE 
export var filters : PoolStringArray 


func _ready():
	_FileDialog.set_current_dir(current_dir)
	_FileDialog.mode = mode
	_FileDialog.filters = filters


func _on_Button_pressed():
	$FileDialog.popup()


func _on_FileDialog_file_selected(path):
	emit_signal("file_selected", path)


func _on_FileDialog_dir_selected(dir):
	emit_signal("dir_selected", dir)


func _on_FileDialog_files_selected(paths):
	emit_signal("files_selected", paths)
