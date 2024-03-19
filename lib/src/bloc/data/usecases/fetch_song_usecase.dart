// song_remote_repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/song_model.dart';
import '../repositories/fetch_song_repo.dart';

class SongRemoteUsecase implements SongRepository {
  final String apiUrl = 'https://your-api-url.com/songs'; // Example API URL

  @override
  Future<List<Song>> fetchSongs() async {
    final response = await http.get(Uri.parse(""));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Song> songs = data.map((json) => Song.fromJson(json)).toList();
      return songs;
    } else {
      throw Exception('Failed to fetch songs');
    }
  }
}
