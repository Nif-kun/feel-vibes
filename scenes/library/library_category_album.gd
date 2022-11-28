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
	var album_list := {}
	# album_list format: {album:MusicPlaylist, album1:MusicPlaylist, etc...}
	for music in music_list:
		var album = music.metadata.get_album()
		if !album.empty():
			if album_list.has(album):
				album_list[album].add(music)
			else:
				var music_playlist = MusicPlaylist.new(album)
				music_playlist.cover_art = music.metadata.get_artworks()[0]
				music_playlist.add(music)
				album_list[album] = music_playlist
	for album in album_list.keys():
		add_card(album_list[album])
	
	if multithread:
		call_deferred("emit_signal", "thread_finished")
