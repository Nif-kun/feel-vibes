extends ScrollContainer

# Nodes
onready var RichLabel := $RichLabel

func set_text(lyrics:String):
	RichLabel.text = lyrics
