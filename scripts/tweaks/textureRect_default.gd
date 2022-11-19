extends TextureRect


export var default_texture : Texture
export var default_modulation := Color.white


# Called when the node enters the scene tree for the first time.
func _ready():
	default()


func default():
	texture = default_texture
	modulate = default_modulation


func set_texture(new_texture):
	if new_texture == null:
		texture = default_texture
	else:
		texture = new_texture
