extends Object
class_name MusicObject

const valid_types := PoolStringArray(["mp3", "wav", "ogg"])
var valid := false


func verify(path:String):
	var dir = Directory.new()
	if dir.file_exists(path):
		for type in valid_types:
			if path.get_extension().to_lower() == type.to_lower():
				valid = true
				return # end function
	valid = false
