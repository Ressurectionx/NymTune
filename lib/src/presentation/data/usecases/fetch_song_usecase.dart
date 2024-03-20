// song_remote_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/song_model.dart';
import '../repositories/fetch_song_repo.dart';

class SongRemoteUsecase implements SongRepository {
  @override
  Future<List<Song>> fetchSongs() async {
    print("Fetching songs...");

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      // Fetch songs from Firestore
      QuerySnapshot querySnapshot = await firestore
          .collection('songs')
          .doc("top_picks")
          .collection("collection")
          .get();

      // Convert query snapshot to a list of songs
      List<Song> songs = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Song.fromJson(data);
      }).toList();
      return songs;
    } catch (e) {
      throw Exception('Failed to fetch songs: $e');
    }
  }
}
