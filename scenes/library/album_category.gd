extends LibraryCategory


func load_items():
	if !item_list.empty():
		var album_list := {}
		for item in item_list:
			if item is Music:
				var album = item.metadata.get_album()
				if album != null and !album.empty():
					if album_list.has(album):
						album_list[album].add(item)
					else:
						var music_playlist = MusicPlaylist.new(album)
						music_playlist.cover_art = item.metadata.get_artworks()[0]
						music_playlist.add(item)
						album_list[album] = music_playlist
		for album in album_list.keys():
			add_card(album_list[album].title, album_list[album].cover_art, album_list[album])
		_built = true
