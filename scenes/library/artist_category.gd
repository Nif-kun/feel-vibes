extends LibraryCategory


func load_items():
	if !item_list.empty():
		var artist_list := {}
		for item in item_list:
			if item is Music:
				var artist = item.metadata.get_artists()[0]
				if artist != "Unknown":
					if artist_list.has(artist):
						artist_list[artist].add(item)
					else:
						var music_playlist = MusicPlaylist.new(artist)
						music_playlist.add(item)
						artist_list[artist] = music_playlist
		for artist in artist_list.keys():
			add_card(artist_list[artist].title, artist_list[artist].cover_art, artist_list[artist])
		_built = true
