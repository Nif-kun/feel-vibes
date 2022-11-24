extends LibraryCategory


func load_items():
	if !item_list.empty():
		var playlist_collection = []
		for item in item_list:
			if item is Music:
				item.metadata.get_album().to_lower()
				pass
#		MusicPlaylist.new("Local Files", item_list)
		
		for playlist in playlist_collection:
			add_card(playlist.title, playlist.cover_art, playlist)
		_built = true
