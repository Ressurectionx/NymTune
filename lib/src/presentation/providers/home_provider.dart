import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../data/models/song_model.dart';
import '../data/usecases/fetch_song_usecase.dart';

class HomeProvider extends ChangeNotifier {
  final SongRemoteUsecase songRemoteUsecase;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = "";
  late http.Client _httpClient;

  List<Song> _songs = [];
  List<Song> get songs => _songs;

  HomeProvider({required this.songRemoteUsecase}) {
    _httpClient = http.Client();
  }

  // Fetch songs from remote source
  Future<void> fetchSongs() async {
    try {
      _songs = await songRemoteUsecase.fetchSongs();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      errorMessage = e.toString(); // Convert error to string for simplicity
      print('Failed to fetch songs: $e');
    }
  }

  // Fetch audio data for a song
  // Fetch audio data for a song and save it to a file
  Future<String> fetchAndSaveAudio(String songUrl) async {
    try {
      // Get the download URL for the storage location
      String downloadUrl = await getDownloadUrl(songUrl);

      // Fetch audio data using the download URL
      final http.Response response =
          await _httpClient.get(Uri.parse(downloadUrl));

      if (response.statusCode == 200) {
        // Save audio data to a temporary file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/audio_temp.mp3');
        await tempFile.writeAsBytes(response.bodyBytes);
        return tempFile.path;
      } else {
        throw Exception('Failed to fetch audio data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching and saving audio: $e');
    }
  }

  // Function to get the downloadable URL from the storage location
  Future<String> getDownloadUrl(String storageLocation) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(storageLocation);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error getting download URL: $e');
    }
  }

  // Clear temporary audio file
  Future<void> clearTempAudio(String filePath) async {
    try {
      final tempFile = File(filePath);
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (e) {
      print('Error clearing temp audio file: $e');
    }
  }
}
