import '../models/song_model.dart'; // Import your song model

abstract class SongRepository {
  Future<List<Song>> fetchSongs();
}
