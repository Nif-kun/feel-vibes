extends TextEditFontResizer


var base_lyrics := ""
var chords_lyrics := ""


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_text(text:String):
	.set_text(text)
	base_lyrics = text
	var line_array = text.split("\n")
	for line in line_array:
		chords_lyrics+="\n"+line
	chords_lyrics = chords_lyrics.trim_suffix("\n")


func base():
	text = base_lyrics

func chords():
	text = chords_lyrics
