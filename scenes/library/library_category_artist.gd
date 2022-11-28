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
	var artist_list := {}
	# artist_list format: {artist:MusicPlaylist, artist1:MusicPlaylist, etc...}
	for music in music_list:
		var artists = music.metadata.get_artists()
		for artist in artists:
			if artist_list.has(artist):
				artist_list[artist].add(music)
			else:
				var music_playlist = MusicPlaylist.new(artist)
				music_playlist.add(music)
				artist_list[artist] = music_playlist
	for artist in artist_list.keys():
		add_card(artist_list[artist])
	
	if multithread:
		call_deferred("emit_signal", "thread_finished")
