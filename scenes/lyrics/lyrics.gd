extends PanelContainer
class_name ContentLyrics

# Nodes
onready var View := $VBox/Widgets/View
onready var Inputs := $VBox/Widgets/Inputs
onready var Lyrics := $VBox/Texts/Lyrics
onready var Chords := $VBox/Texts/Chords
onready var EditBtn := $VBox/Widgets/Edit
onready var SaveBtn := $VBox/Widgets/Save
onready var CancelBtn := $VBox/Widgets/Cancel
onready var DeleteBtn := $VBox/Widgets/Delete

# Private
var _music : Music
var _chord_list := []
var _adding := false
var _editting := false

func _ready():
	Lyrics.mouse_default_cursor_shape = Control.CURSOR_ARROW
	Chords.mouse_default_cursor_shape = Control.CURSOR_ARROW


func set_text(text:String, music:Music=null):
	reset()
	_music = music
	Lyrics.set_text(text)
	View.clear()
	View.set_index(0)
	if GlobalChords.chords_collection.has(_music.metadata.get_title()):
		_chord_list = GlobalChords.chords_collection.get(_music.metadata.get_title())
		for chord in _chord_list:
			var item_label = "["+chord["instrument"]+"] "+chord["title"]
			View.add(item_label)
	else:
		_chord_list = []

func reset(saved:bool=false):
	if !saved:
		Lyrics.show()
		Chords.hide()
	Chords.readonly = true
	Inputs.hide()
	Inputs.set_instrument("")
	Inputs.set_title("")
	SaveBtn.hide()
	CancelBtn.hide()
	View.show()
	DeleteBtn.hide()
	EditBtn.show()
	_adding = false
	_editting = false
	


func edit():
	View.hide()
	DeleteBtn.hide()
	EditBtn.hide()
	Chords.show()
	Chords.readonly = false
	Inputs.show()
	SaveBtn.show()
	CancelBtn.show()
	_editting = true


func _on_Edit_pressed():
	if View.get_index() == 0:
		EditBtn.hide()
		Lyrics.mouse_default_cursor_shape = Control.CURSOR_IBEAM
		Lyrics.readonly = false
		SaveBtn.show()
		CancelBtn.show()
	else:
		var dict = _chord_list[View.get_index()-2]
		Chords.mouse_default_cursor_shape = Control.CURSOR_IBEAM
		Inputs.set_title(dict["title"])
		Inputs.set_instrument(dict["instrument"])
		edit()


func _on_Save_pressed():
	if !Lyrics.readonly:
		Lyrics.mouse_default_cursor_shape = Control.CURSOR_ARROW
		Lyrics.readonly = true
		if _music != null:
			_music.metadata.set_lyrics(Lyrics.text)
	# save for chords
	if _music != null:
		Chords.mouse_default_cursor_shape = Control.CURSOR_ARROW
		var new_chords := { 
			"instrument":Inputs.get_instrument(), 
			"title":Inputs.get_title(),
			"chords":Chords.get_chords() }
		if _editting and View.get_index() > 1:
			_chord_list[View.get_index()-2]["instrument"] = Inputs.get_instrument()
			_chord_list[View.get_index()-2]["title"] = Inputs.get_title()
			_chord_list[View.get_index()-2]["chords"] = Chords.get_chords() 
			View.rename(View.get_index(), "["+Inputs.get_instrument()+"] "+Inputs.get_title())
		if _adding:
			_chord_list.append(new_chords)
			View.add("["+Inputs.get_instrument()+"] "+Inputs.get_title())
			View.set_index(View.get_last_index())
		GlobalChords.chords_collection[_music.metadata.get_title()] = _chord_list
		if View.get_index() > 1:
			reset(true)
			DeleteBtn.show()
			return # escape
	reset()


func _on_Cancel_pressed():
	if !Lyrics.readonly:
		Lyrics.mouse_default_cursor_shape = Control.CURSOR_ARROW
		Lyrics.readonly = true
		if _music != null:
			Lyrics.text = _music.metadata.get_lyrics()
		reset()
	elif View.get_index() > 1:
		Chords.mouse_default_cursor_shape = Control.CURSOR_ARROW
		Chords.setup(Lyrics.get_line_count(), Lyrics.text, _chord_list[View.get_index() - 2]["chords"])
		reset(true)
		DeleteBtn.show()
	else:
		reset()
		


func _on_View_pressed_lyrics():
	reset()


func _on_View_pressed_add():
	reset()
	Chords.clear()
	Lyrics.hide()
	_adding = true
	Chords.setup(Lyrics.get_line_count(), Lyrics.text, "")
	edit()


func _on_View_pressed_chord(index):
	DeleteBtn.show()
	# show delete button
	Lyrics.hide()
	Chords.setup(Lyrics.get_line_count(), Lyrics.text, _chord_list[index - 2]["chords"])
	Chords.show()


func _on_Delete_pressed():
	_chord_list.remove(View.get_index() - 2)
	View.remove_selected()
	reset()
	View.set_index(0)
