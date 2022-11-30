extends TextEdit
class_name TextEditFontResizer

# Signals
signal font_resized(num)

# Exports
export var enabled := true
export var space_extra := false setget set_space_extra
export var space_margin := 7
export var font_size_m := 12
export var font_size_s := 8

# Private 
var _resized_at_width : PoolIntArray = [0,0] # full_size, mid_size

# Public
var font_size_default : int

# Called when the node enters the scene tree for the first time.
func _ready():
	font_size_default = get_font("font").size
	# warning-ignore:return_value_discarded
	connect("item_rect_changed", self, "_item_rect_changed")


func set_space_extra(flag:bool):
	space_extra = flag
	if !flag:
		get_font("font").extra_spacing_top = 0
	else:
		get_font("font").extra_spacing_top = get_font("font").size + space_margin


func set_text(text:String):
	.set_text(text)
	_adjust_font_size()


func _item_rect_changed():
	if enabled:
		_adjust_font_size()


func _adjust_font_size():
	if get_total_visible_rows() > get_line_count():
		if get_font("font").size > font_size_m and rect_size.x > _resized_at_width[1]:
			get_font("font").size = font_size_m
			if space_extra:
				get_font("font").extra_spacing_top = font_size_m + space_margin
			_resized_at_width[0] = int(rect_size.x + 15)
			emit_signal("font_resized", 2)
		elif get_font("font").size > font_size_s:
			get_font("font").size = font_size_s
			if space_extra:
				get_font("font").extra_spacing_top = font_size_s + space_margin
			_resized_at_width[1] = int(rect_size.x + 15)
			emit_signal("font_resized", 3)
	elif rect_size.x > _resized_at_width[1] and rect_size.x < _resized_at_width[0]:
		get_font("font").size = font_size_m
		if space_extra:
			get_font("font").extra_spacing_top = font_size_m + space_margin
		emit_signal("font_resized", 2)
	elif rect_size.x > _resized_at_width[0]:
		get_font("font").size = font_size_default
		if space_extra:
			get_font("font").extra_spacing_top = font_size_default + space_margin
		emit_signal("font_resized", 1)
