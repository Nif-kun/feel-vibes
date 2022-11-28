extends AutoGrid
class_name LibraryCategory

# CAUTION: multi-threading causes un-catchable crashes. It is not recommended!

# Signals
signal card_pressed(music_card)
# warning-ignore:unused_signal
signal thread_finished

# Private
var _music_card_scene = preload("res://scenes/library/MusicCard.tscn")
var _thread : Thread

# Public
var card_list := [] # an array of MusicCard


# warning-ignore:unused_argument
func fill(music_list:Array, multithread:=false): # Override
	clear()
	if multithread:
		_thread = Thread.new()
		# warning-ignore:return_value_discarded
		connect("thread_finished", self, "_on_Thread_finished")

func clear():
	for child in get_children():
		if child is MusicCard:
			remove_child(child)
	card_list.clear()


func add_card(playlist:MusicPlaylist, editable:=false):
	var music_card = _music_card_scene.instance()
	if music_card is MusicCard:
		music_card.set_playlist(playlist)
		music_card.set_editable(editable)
		# warning-ignore:return_value_discarded
		music_card.connect("pressed", self, "_on_MusicCard_pressed")
	card_list.append(music_card)
	add_child(music_card)

func remove_card(music_card:MusicCard):
	card_list.erase(music_card)
	remove_child(music_card)


func _on_MusicCard_pressed(music_card):
	emit_signal("card_pressed", music_card)


func _on_Thread_finished():
	if _thread != null:
		_thread.wait_to_finish()
		_thread = null


func _exit_tree():
	if _thread != null:
		_thread.wait_to_finish()
