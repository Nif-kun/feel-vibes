using Godot;
using System.IO;
using System.Linq;

// Music Metadata Reader (MDReader)
public class MDReader : Reference
{

	public static void SetComment(string path, string comment) 
	{
		var tfile = TagLib.File.Create(@path);
		tfile.Tag.Comment = comment;
		tfile.Save();
	}

	public static string GetComment(string path) 
	{
		return TagLib.File.Create(@path).Tag.Comment;
	}

	public static string GetTitle(string path)
	{
		return TagLib.File.Create(@path).Tag.Title;
	}

	public static string[] GetArtists(string path) {
		return TagLib.File.Create(@path).Tag.Performers;
	}

	public static string GetAlbum(string path)
	{
		return TagLib.File.Create(@path).Tag.Album;
	}

	public static string[] GetAlbumArtists(string path) {
		return TagLib.File.Create(@path).Tag.AlbumArtists;
	}

	public static void SetLyrics(string path, string lyrics) 
	{
		var tfile = TagLib.File.Create(@path);
		tfile.Tag.Lyrics = lyrics;
		tfile.Save();
	}

	public static string GetLyrics(string path)
	{
		return TagLib.File.Create(@path).Tag.Lyrics;
	}

	public static int GetTrack(string path)
	{
		return (int)TagLib.File.Create(@path).Tag.Track;
	}

	public static string[] GetGenres(string path)
	{
		return TagLib.File.Create(@path).Tag.Genres;
	}

	public static Godot.Collections.Array<ImageTexture> GetPictures(string path)
	{
		Godot.Collections.Array<ImageTexture> imageTextureArray = new();
		var iPictures = TagLib.File.Create(@path).Tag.Pictures;
		foreach (var picture in iPictures)
		{
			Image image = new();
			ImageTexture imageTexture = new();
			MemoryStream memoryStream = new(picture.Data.Data);
			image.LoadJpgFromBuffer(memoryStream.ToArray());
			imageTexture.CreateFromImage(image);
			imageTextureArray.Add(imageTexture);
		}
		return imageTextureArray;
	}

	public static Godot.Collections.Dictionary GetCommon(string path) {
		Godot.Collections.Dictionary commonData = new();
		Godot.Collections.Array<ImageTexture> imageTextureArray = new();
		var tagFile = TagLib.File.Create(@path);

		commonData.Add("Title", tagFile.Tag.Title);
		commonData.Add("Artists", tagFile.Tag.Performers);
		commonData.Add("Album", tagFile.Tag.Album);
		commonData.Add("AlbumArtists", tagFile.Tag.AlbumArtists);
		commonData.Add("Track", (int)tagFile.Tag.Track);
		commonData.Add("Genres", tagFile.Tag.Genres);
		commonData.Add("Lyrics", tagFile.Tag.Lyrics);
		commonData.Add("Comment", tagFile.Tag.Comment);
		
		foreach (var picture in tagFile.Tag.Pictures)
		{
			Image image = new();
			ImageTexture imageTexture = new();
			MemoryStream memoryStream = new(picture.Data.Data);
			image.LoadJpgFromBuffer(memoryStream.ToArray());
			imageTexture.CreateFromImage(image);
			imageTextureArray.Add(imageTexture);
		}
		commonData.Add("Artworks", imageTextureArray);
		return commonData;
	}

}
