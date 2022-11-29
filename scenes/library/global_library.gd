extends Node

var custom_music_cards := [] # custom MusicCard array
var current_playlist_card : MusicCard
var dragging_item := false
var drag_pos_highlight : Control

func get_custom_playlists() -> Array:
	var playlists := []
	for music_card in custom_music_cards:
		if music_card.playlist.title.to_lower() != "local files":
			playlists.append(music_card.playlist)
	return playlists


func add_playlist_song(title:String, music:Music):
	for music_card in custom_music_cards:
		if music_card.playlist.title.to_lower() == title.to_lower():
			for _music in music_card.playlist.list:
				if _music == music:
					return
				else:
					music_card.playlist.list.append(music) 
