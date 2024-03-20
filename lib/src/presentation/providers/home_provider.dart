import 'package:flutter/material.dart';

import '../data/models/song_model.dart';
import '../data/usecases/fetch_song_usecase.dart';

class HomeProvider extends ChangeNotifier {
  final SongRemoteUsecase songRemoteUsecase;
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = "";
  HomeProvider({required this.songRemoteUsecase});

  List<Song> _songs = [];
  List<Song> get songs => _songs;

  Future<void> fetchSongs() async {
    try {
      _songs = await songRemoteUsecase.fetchSongs();
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      hasError = true;
      // Handle error
      errorMessage = e.toString(); // Convert error to string for simplicity
      print('Failed to fetch songs: $e');
    }
  }
}
