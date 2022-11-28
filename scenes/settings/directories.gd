extends VBoxContainer
class_name SettingsDirectories

# Signals
signal music_collected(music_list)
signal playlist_collected
signal chords_collected

# Nodes
onready var MusicDir := $Margin/VBox/MusicDir
onready var ScanBtn := $Margin/VBox/Scan
onready var EmptyDirNotif := $Notif/Control/EmptyDir
onready var WarnCheckbox := $Margin/VBox/NotifHandle/CheckBox

# Objects
var music_collection : AudioCollection
var playlist_collection := FileCollection.new()
var chords_collection := FileCollection.new()

# Private
var _key_warn_empty := "notify_empty"
var _key_music := "music_dir"

# Public
var data = {
	_key_warn_empty:true,
	_key_music:""
}
var playlist_dir := Defaults.get_playlist_dir()
var chords_dir := Defaults.get_chords_dir()
var music_dir_empty := true


func _ready():
	scan_playlist()
	scan_chords()


func set_data(new_data:Dictionary):
	if new_data != null:
		data[_key_warn_empty] = new_data.get(_key_warn_empty, true)
		data[_key_music] = new_data.get(_key_music, "")
	MusicDir.set_dir(data[_key_music])
	WarnCheckbox.pressed = !data[_key_warn_empty]
	if data[_key_warn_empty] and data[_key_music].empty():
		EmptyDirNotif.popup()
	else:
		music_dir_empty = false

func get_data() -> Dictionary:
	data[_key_music] = MusicDir.get_dir()
	data[_key_warn_empty] = !WarnCheckbox.pressed
	return data


func music() -> Array:
	if music_collection != null:
		return music_collection.list
	return []

func playlist() -> Array:
	return playlist_collection.list

func chords() -> Array:
	return chords_collection.list


func scan_music():
	if !MusicDir.get_dir().empty() and MusicDir.valid:
		music_collection = AudioCollection.new(MusicDir.get_dir(), 5, true, ["mp3", "ogg", "wav"])
		# warning-ignore:return_value_discarded
		music_collection.connect("audio_collected", self, "_on_music_collected")
		ScanBtn.disabled = true

func scan_playlist():
	playlist_collection.renew_thread(false)
	playlist_collection.open(playlist_dir, 1, true, [Defaults.playlist_extension])
	emit_signal("playlist_collected")

func scan_chords():
	chords_collection.renew_thread(false)
	chords_collection.open(chords_dir, 1, true, [Defaults.chords_extension])
	emit_signal("chords_collected")


func _on_Scan_pressed():
	scan_music()


func _on_music_collected(music_list):
	emit_signal("music_collected", music_list)
	ScanBtn.disabled = false


func _on_MusicDir_text_validated(flag):
	music_dir_empty = !flag
