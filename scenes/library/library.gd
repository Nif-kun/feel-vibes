extends PanelContainer
class_name ContentLibrary

# TODO make repositionable playlist. 
# TODO copy playlist on left side, this is for main window. Add search.


# Signals
signal music_selected(music_playlist)
signal setup_complete

# Nodes
onready var Content := $VBox/Content
onready var PlaylistCards := $VBox/Content/PBox/PlaylistCards
onready var AlbumCards := $VBox/Content/PBox/AlbumCards
onready var ArtistCards := $VBox/Content/PBox/ArtistsCards
onready var Playlist := $VBox/Content/PBox/Playlist
onready var BackBtn := $VBox/Buttons/Back
onready var PlaylistBtn := $VBox/Buttons/Playlist
onready var AddPlaylistBtn := $VBox/Buttons/AddPlaylist


func setup(music_list:Array):
	PlaylistCards.fill(music_list)
	AlbumCards.fill(music_list)
	ArtistCards.fill(music_list)
	emit_signal("setup_complete")


func _on_Playlist_toggled(button_pressed):
	if button_pressed:
		Content.show_playlist_cards()
		BackBtn.disabled = true
		AddPlaylistBtn.show()

func _on_Album_toggled(button_pressed):
	if button_pressed:
		Content.show_album_cards()
		BackBtn.disabled = true
		AddPlaylistBtn.hide()

func _on_Artist_toggled(button_pressed):
	if button_pressed:
		Content.show_artist_cards()
		BackBtn.disabled = true
		AddPlaylistBtn.hide()

func _on_MusicCard_pressed(music_card):
	if music_card.playlist != null:
		Playlist.fill(music_card, Content.get_current())
		Content.show_playlist()
		BackBtn.disabled = false
		AddPlaylistBtn.hide()


func _on_Playlist_item_pressed(music_playlist):
	emit_signal("music_selected", music_playlist)


func _on_Back_pressed():
	Content.show_previous()
	BackBtn.disabled = true
	if PlaylistBtn.pressed:
		AddPlaylistBtn.show()


func _on_AddPlaylist_pressed():
	var playlist = MusicPlaylist.new("New playlist")
	playlist.generate_id()
	playlist.set_file_path(Defaults.get_playlist_dir()+"/"+playlist.id)
	ShortLib.write_text_file(playlist.file_path, JSON.print(playlist.get_data(), "\t"))
	Content.PlaylistCards.add_card(playlist, true)


func _on_Playlist_deleted():
	Content.show_previous()
