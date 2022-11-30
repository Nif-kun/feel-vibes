extends TextEditFontResizer

# Private
var _cursor_buffer := 0
var _text_buffer := ""
var _rows := 0


func clear():
	_text_buffer= ""
	text = ""
	_rows = 0


func setup(rows:int, lyrics:String, chords:String):
	clear()
	_rows = rows
	var new_rows := 0
	var lyrics_array := lyrics.split("\n", true)
	var chords_array := chords.split("\n", true)
	for i in range(0, rows):
		if i < chords_array.size():
			text += chords_array[i]+"\n"
			new_rows+=1
		else:
			text += "\n"
			new_rows+=1
		if i < lyrics_array.size():
			text += lyrics_array[i]+"\n"
			new_rows+=1
		else:
			text += "\n"
			new_rows+=1
	text = text.trim_suffix("\n")
	_text_buffer = text
	_rows = new_rows


func get_chords() -> String:
	var chords = ""
	var split_text = text.split("\n")
	var line_count = split_text.size()
	for line in range(0, line_count):
		if line % 2 == 0:
			if !split_text[line].empty():
				chords += split_text[line]+"\n"
	chords = chords.trim_suffix("\n")
	return chords


func _on_Chords_text_changed():
	if get_line_count() != _rows:
		text = _text_buffer
		cursor_set_line(_cursor_buffer)
	elif (cursor_get_line() % 2 != 0):
		text = _text_buffer
		cursor_set_line(_cursor_buffer)
	else:
		_text_buffer = text


func _on_Chords_cursor_changed():
	_cursor_buffer = cursor_get_line()
