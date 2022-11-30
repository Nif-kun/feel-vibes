extends HBoxContainer

# Nodes
onready var InstrumentEdit := $Instrument/LineEdit
onready var TitleEdit := $Title/LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_instrument(text:String):
	InstrumentEdit.text = text

func get_instrument() -> String:
	if !InstrumentEdit.text.empty():
		return InstrumentEdit.text
	return "Unknown"


func set_title(text:String):
	TitleEdit.text = text

func get_title() -> String:
	if !TitleEdit.text.empty():
		return TitleEdit.text
	return "Untitled"

