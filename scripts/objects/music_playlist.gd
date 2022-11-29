extends Reference
class_name MusicPlaylist

# Dependencies:
#	ShortLib by Nif

# Signals
signal current_changed(music)

# Public 
var title := "Untitled"
var cover_art : Texture
var list := [] # Music class array
var file_path := ""
var id := ""

# Private
var _FairNG : FairNG
var _cover_art_path := ""
var _current_music_index := 0
var _initial_list_size := 0 # called only on one-run start functions
var _music_played_count := 0


func _init(new_title:String="Untitled", new_list:=[], cover_art_path:String="", index:=0, uid:=false):
	title = new_title
	_cover_art_path = cover_art_path
	cover_art = ShortLib.load_texture(cover_art_path)
	list = new_list
	_current_music_index = _clamp_index(index)
	_initial_list_size = list.size()
	if uid:
		id = UUID.v4()


func set_title(new_title:String):
	title = new_title

func get_title() -> String:
	return title

func set_cover_art(path:String):
	_cover_art_path = path
	cover_art = ShortLib.load_texture(path)

func get_cover_art() -> Texture:
	return cover_art

func set_list(new_list:Array):
	list = new_list

func get_list() -> Array:
	return list

func set_file_path(path:String):
	file_path = path

func get_file_path() -> String:
	return file_path

func generate_id():
	id = UUID.v4()


func add(music:Music):
	if list.empty():
		list.append(music)
		return # end function
	for _music in list:
		if _music.file_path == music.file_path:
			return # end function
	list.append(music)

func remove(music:Music):
	var music_list := []
	for _music in list:
		if _music.file_path == music.file_path:
			music_list.append(_music)
	for _music in music_list:
		list.erase(_music)


func next():
	if _current_music_index + 1 < list.size():
		_current_music_index += 1
		emit_signal("current_changed", get_current())

func previous():
	if _current_music_index > 0:
		_current_music_index -= 1
		emit_signal("current_changed", get_current())

func shuffle():
	if _FairNG == null or _initial_list_size != list.size():
		_initial_list_size = list.size()
		_FairNG = FairNG.new(list.size()) 
	if list.size() > 1:
		_music_played_count += 1
		if _music_played_count > list.size():
			_FairNG.reset_state()
			_music_played_count = 0
			return # end function
		_current_music_index = _FairNG.randi()
		emit_signal("current_changed", get_current())


func set_position(music:Music, index:int):
	if list.size() > 1: # requires two music, pointless if one only.
		var selected_music : Music
		for _music in list:
			if _music.file_path == music.file_path:
				selected_music = _music
				break
		if selected_music != null:
			var clamped_index = _clamp_index(index)
			var current_music = get_current()
			
			list.erase(selected_music)
			list.insert(clamped_index, selected_music)
			
			var new_current_index = list.find(current_music)
			if new_current_index >= 0:
				_current_music_index = new_current_index

func get_position(music:Music) -> int:
	if !list.empty():
		return list.find(music)
	return -1


func set_current(index:int):
	_current_music_index = _clamp_index(index)

func get_current() -> Music:
	if !list.empty():
		return list[_current_music_index]
	return null

func get_next() -> Music:
	return list[_clamp_index(_current_music_index+1)]

func get_previous() -> Music:
	return list[_clamp_index(_current_music_index-1)]


# Data format: {"id":id, "title":title, "cover_art":path, "list":list }
func set_data(music_list:Array, data:Dictionary):
	if data.size() > 0:
		id = data.get("id", UUID.v4())
		title = data.get("title", "Untitled")
		_cover_art_path = data.get("cover_art_path", "")
		cover_art = ShortLib.load_texture(_cover_art_path)
		var path_list = data.get("music_path_list", [])
		for path in path_list: # this as baseloop mirrors path_list sequence.
			for music in music_list:
				if music.file_path == path:
					list.append(music)
	_initial_list_size = list.size()

func get_data() -> Dictionary:
	var music_path_list = []
	for music in list:
		music_path_list.append(music.file_path)
	var data = { 
		"id":id,
		"title":title,
		"cover_art_path":_cover_art_path,
		"music_path_list":music_path_list
		}
	return data


func _clamp_index(index:int) -> int:
	var max_size = 0
	if list.size() > 1:
		max_size = list.size() - 1
	return int(clamp(index, 0, max_size))
