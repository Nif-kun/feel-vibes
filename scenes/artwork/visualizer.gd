extends PanelContainer

# Nodes
onready var AudioVisualizer := $AudioVisualizer

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioVisualizer.position = rect_size/2
	# warning-ignore:return_value_discarded
	connect("resized", self, "_resized")

func _resized():
	AudioVisualizer.position = rect_size/2
