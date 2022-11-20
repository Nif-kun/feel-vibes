extends Object
class_name MusicPlaylist

# Dependencies:
#	ShortLib by Nif

# Public 
var title := ""
var cover_art : Texture
var list := [] # Music class array

# Private
var _FairNG : FairNG
var _cover_art_path := ""
var _current_music_index := 0
var _initial_list_size := 0 # called only on one-run start functions
var _music_played_count := 0


func _init(new_title:String, new_list:=[], cover_art_path:String="", index:=0):
	title = new_title
	_cover_art_path = cover_art_path
	cover_art = ShortLib.load_texture(cover_art_path)
	list = new_list
	_current_music_index = _clamp_index(index)
	_initial_list_size = list.size()


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

func previous():
	if _current_music_index > 0:
		_current_music_index -= 1

func reposition(music:Music, index:int):
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
			if new_current_index > 0:
				_current_music_index = new_current_index

# CAUTION keep watch when testing if fair rng works.
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


# CAUTION unsure if setget of data actually properly works.
# Data format: { "title":title, "cover_art":path, "list":list }
func set_data(music_list:Array, data:Dictionary):
	if data.size() > 0:
		title = data.get("title", "UNTITLED")
		cover_art = ShortLib.load_texture(data.get("cover_art_path", "")) 
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
		"title":title,
		"cover_art_path":_cover_art_path,
		"music_path_list":music_path_list
		}
	return data


# CAUTION potential conversion error as clamp takes float.
func _clamp_index(index:int) -> int:
	var max_size = 0
	if list.size() > 1:
		max_size = list.size() - 1
	return int(clamp(index, 0, max_size))
