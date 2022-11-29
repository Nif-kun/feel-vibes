extends LibraryCategory


func fill(music_list:Array, multithread:=false):
	# Base function clears out previous cards added to scene tree and card_list.
	# If multithread, creates a Thread object.
	.fill([], multithread)
	if multithread:
		# warning-ignore:return_value_discarded
		_thread.start(self, "_custom_fill", music_list)
	else:
		_custom_fill(music_list, false)


func _custom_fill(music_list:Array, multithread:=true):
	var playlist_list = []
	
	# Construct Local Files default
	var local_files_playlist = MusicPlaylist.new("Local Files", music_list)
	local_files_playlist.cover_art = Defaults.folder_icon
	add_card(local_files_playlist)
	
	# Collect playlists
	var json_collection = JSONCollection.new(Defaults.get_playlist_dir(), 1, true, [], false)
	for data in json_collection.list:
		var playlist = MusicPlaylist.new()
		playlist.set_file_path(data["json_file_path"])
		if data is Dictionary:
			playlist.set_data(music_list, data)
			playlist_list.append(playlist)
	
	# For loop for every playlist
	for playlist in playlist_list:
		add_card(playlist, true)
		
	if multithread:
		call_deferred("emit_signal", "thread_finished")

func add_card(playlist:MusicPlaylist, editable:=false):
	.add_card(playlist, editable)
	GlobalLibrary.custom_music_cards = card_list
