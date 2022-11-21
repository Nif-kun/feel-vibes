extends ScrollContainer

# Public 
export var auto := false
# warning-ignore:export_hint_type_mistmatch
export(int, 1.0, 100.0) var duration := 1.0
export var on_hover := true

var _Tween : SceneTreeTween


# Called when the node enters the scene tree for the first time.
func _ready():
	if on_hover:
		# warning-ignore:return_value_discarded
		connect("mouse_entered", self, "_mouse_entered")
		# warning-ignore:return_value_discarded
		connect("mouse_exited", self, "_mouse_exited")
		# warning-ignore:return_value_discarded
		connect("resized", self, "_resized")


func _mouse_entered():
	var hscroll_bar = get_h_scrollbar()
	if hscroll_bar.visible:
		if _Tween == null or !_Tween.is_valid():
			_Tween = create_tween().bind_node(self)
			# warning-ignore:return_value_discarded
			_Tween.tween_property(hscroll_bar, "value", hscroll_bar.max_value, duration)
			# warning-ignore:return_value_discarded
			_Tween.tween_property(hscroll_bar, "value", hscroll_bar.min_value, duration/4)
		elif _Tween.is_running():
			_Tween.pause()
		else:
			# warning-ignore:return_value_discarded
			_Tween.tween_property(hscroll_bar, "value", hscroll_bar.max_value, duration)
			# warning-ignore:return_value_discarded
			_Tween.tween_property(hscroll_bar, "value", hscroll_bar.min_value, duration/2)
			_Tween.stop()


func _mouse_exited():
	if _Tween != null and _Tween.is_valid() and !_Tween.is_running():
		_Tween.play()


func _resized():
	if _Tween != null and _Tween.is_valid() and _Tween.is_running():
		var hscroll_bar = get_h_scrollbar()
		if !hscroll_bar.visible:
			_Tween.kill()
			hscroll_bar.value = hscroll_bar.min_value
