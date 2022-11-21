extends HBoxContainer

# Nodes
onready var VolSlider := $Slider
onready var Mute := $Mute

# Private
var _master_bus := AudioServer.get_bus_index("Master")
var _volume_buffer := 1 # one is equivalent to null-check in this condition
export var _volume_full : Texture = Defaults.volume_full
export var _volume_half : Texture = Defaults.volume_half
export var _volume_empty : Texture = Defaults.volume_empty


func _on_Slider_value_changed(value):
	AudioServer.set_bus_volume_db(_master_bus, value)
	if value == VolSlider.min_value:
		Mute.pressed = true
		AudioServer.set_bus_mute(_master_bus, true)
	else:
		if Mute.pressed:
			_volume_buffer = 1
			Mute.pressed = false
		if value > (VolSlider.min_value / 2):
			if _volume_full != null:
				Mute.icon = _volume_full
		if value < (VolSlider.min_value / 2):
			if _volume_half != null:
				Mute.icon = _volume_half
		AudioServer.set_bus_mute(_master_bus, false)


func _on_Mute_toggled(button_pressed):
	if button_pressed:
		if VolSlider.value > VolSlider.min_value:
			_volume_buffer = VolSlider.value
			VolSlider.value = VolSlider.min_value
		if _volume_empty != null:
			Mute.icon = _volume_empty
	else:
		if _volume_buffer != 1:
			VolSlider.value = _volume_buffer
