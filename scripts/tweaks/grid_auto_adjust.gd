extends GridContainer
class_name AutoGrid

# Public
export var item_min_width := 1.0


# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	connect("resized", self, "_resized")


func _resized():
	var col = int((rect_size.x - (get_constant("hseparation")*2)) / (item_min_width+get_constant("hseparation")))
	if col > 0:
		columns = col
