extends ScrollContainer
class_name ContentLyrics

# Nodes
onready var RichLabel := $RichLabel

func set_text(lyrics:String):
	RichLabel.text = lyrics
