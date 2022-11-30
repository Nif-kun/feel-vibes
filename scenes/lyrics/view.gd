extends HBoxContainer

# Signals
signal pressed_lyrics
signal pressed_add
signal pressed_chord(index)

# Nodes
onready var OptionsBtn := $OptionButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func get_last_index() -> int:
	return OptionsBtn.get_item_count() - 1


func set_index(index:int):
	OptionsBtn.selected = index

func get_index() -> int:
	return OptionsBtn.selected


func rename(index:int, text:String):
	OptionsBtn.set_item_text(index, text)

func add(text:String):
	OptionsBtn.add_item(text)

func remove_selected():
	OptionsBtn.remove_item(OptionsBtn.selected)

func clear():
	while OptionsBtn.get_item_count() > 2:
		OptionsBtn.remove_item(2)


func _on_OptionButton_item_selected(index):
	match index:
		0:
			emit_signal("pressed_lyrics")
		1:
			OptionsBtn.selected = 0
			emit_signal("pressed_add")
		_:
			emit_signal("pressed_chord", index)
