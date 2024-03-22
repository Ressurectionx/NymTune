// song_remote_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/song_model.dart';
import '../repositories/fetch_song_repo.dart';

class SongRemoteUsecase implements SongRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  DocumentSnapshot? _lastDocument; // Keep track of the last document
  bool _hasMore = true; // Flag to indicate if there are more documents to fetch

  @override
  Future<List<Song>> fetchSongs({int limit = 10}) async {
    if (!_hasMore) {
      print("No more songs to fetch.");
      return [];
    }

    try {
      Query query = firestore
          .collection('songs')
          .doc("top_picks")
          .collection("collection")
          .orderBy('title')
          .limit(limit);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      QuerySnapshot querySnapshot = await query.get();
      List<Song> songs = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Song.fromJson(data);
      }).toList();

      if (querySnapshot.docs.isNotEmpty) {
        _lastDocument = querySnapshot.docs.last;
      } else {
        _hasMore = false;
      }

      return songs;
    } catch (e) {
      throw Exception('Failed to fetch songs: $e');
    }
  }
}
