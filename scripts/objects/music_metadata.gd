extends MusicObject
class_name MusicMetadata

# IDEA: add setter functions. (Most likely requires MDReader modification.)

# Dependencies:
#	MDReader by Nif

var data := {
	"Title":"",
	"Artists":[],
	"Artworks":[],
	"Album":"",
	"AlbumArtists":[],
	"Track":-1,
	"Genres":[],
	"Lyrics":"",
	"Comment":""
}

var file_name : String = "Untitled"
var file_path := ""


func _init(path:String=""):
	read(path)


func read(path:String):
	verify(path)
	if valid:
		file_path = path
		var MDReader = Defaults.mdreader_script.new()
		data = MDReader.GetCommon(path)
		if File.new().file_exists(path):
			var index_x = path.find_last("/")
			var index_y = path.find_last("\\")
			if index_x > -1:
				file_name = path.substr(index_x+1)
			elif index_y > -1:
				file_name = path.substr(index_y+1)


func get_title() -> String:
	var new_title = data.get("Title")
	if new_title != null and !new_title.empty():
		return new_title
	return file_name

func get_artists() -> PoolStringArray:
	var artists = data.get("Artists")
	if artists != null and !artists.empty() and !artists[0].empty():
		return artists
	return PoolStringArray()

func get_artworks() -> Array:
	var artworks = data.get("Artworks")
	if artworks != null and !artworks.empty():
		return artworks
	return [null]

func get_album() -> String:
	var album = data.get("Album")
	if album != null:
		return album 
	return ""

func get_album_artists() -> PoolStringArray:
	var album_artists = data.get("AlbumArtists")
	if album_artists != null:
		return album_artists
	return PoolStringArray(["Unknown"])

func get_track() -> int:
	var track = data.get("Track")
	if track != null:
		return track
	return -1

func get_genres() -> PoolStringArray:
	return data.get("Genres", [])

func set_lyrics(lyrics:String):
	if valid:
		var MDReader = Defaults.mdreader_script.new()
		data["Lyrics"] = lyrics
		MDReader.SetLyrics(file_path, lyrics)

func get_lyrics() -> String:
	var lyrics = data.get("Lyrics", "")
	if lyrics != null:
		return lyrics
	return ""

func get_comment() -> String:
	var comment = data.get("Comment", "")
	if comment != null:
		return comment
	return ""

func set_comment(comment:String):
	if valid:
		var MDReader = Defaults.mdreader_script.new()
		data["Comment"] = comment
		MDReader.SetComment(file_path, comment)
