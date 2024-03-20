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

  Future<String> fetchAndSaveAudio(String songUrl, String songId) async {
    String filePath = '${(await getTemporaryDirectory()).path}/$songId.mp3';
    File file = File(filePath);

    // Check if the file already exists. If it does, return the path immediately.
    if (await file.exists()) {
      return filePath;
    }

    try {
      String downloadUrl = await getDownloadUrl(songUrl);
      final request = await HttpClient().getUrl(Uri.parse(downloadUrl));
      final response = await request.close();

      // Save the streamed audio into file in chunks.
      await response.pipe(file.openWrite());
      notifyListeners();
      return filePath;
    } catch (e) {
      throw Exception('Error fetching and saving audio stream: $e');
    }
  }

// Function to get the downloadable URL from the storage location
  Future<String> getDownloadUrl(String storageLocation) async {
    try {
      // Create a Reference from the storage location
      Reference ref = FirebaseStorage.instance.refFromURL(storageLocation);

      // Get the download URL
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
