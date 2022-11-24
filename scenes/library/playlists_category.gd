extends LibraryCategory


func load_items():
	if !item_list.empty():
		var playlist_collection = []
		playlist_collection.append(MusicPlaylist.new("Local Files", item_list))
		# for loop for every playlist
		for playlist in playlist_collection:
			add_card(playlist.title, playlist.cover_art, playlist)
		_built = true
