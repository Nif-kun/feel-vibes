extends Object
class_name MusicMetadata

var data := {
	"Title":"",
	"Artists":[],
	"Artworks":[],
	"Album":"",
	"AlbumArtists":[],
	"Track":-1,
	"Genres":[],
	"Lyrics":""
}

func _init(path:String):
	var MDReader = Defaults.mdreader_script.new()
	data = MDReader.GetCommon(path)


func get_title() -> String:
	return data.get("Title")

func get_artists() -> PoolStringArray:
	return data.get("Artists")

func get_artworks() -> Array:
	return data.get("Artworks")

func get_album() -> String:
	return data.get("Album")

func get_album_artists() -> PoolStringArray:
	return data.get("AlbumArtists")

func get_track() -> int:
	return data.get("Track")

func get_genres() -> PoolStringArray:
	return data.get("Genres")

func get_lyrics() -> String:
	return data.get("Lyrics")
