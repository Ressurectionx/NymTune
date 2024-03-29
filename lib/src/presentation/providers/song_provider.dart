import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/song_model.dart';
import '../data/usecases/fetch_song_usecase.dart';

class SongProvider extends ChangeNotifier {
  final SongRemoteUsecase songRemoteUsecase;
  late AudioPlayer _audioPlayer;
  late List<Song> _songs;
  late Song? _currentSong;
  late bool _isPlaying;
  late String _audioFilePath;
  late bool _hasFetchedAudio;
  late bool _isFetchingAudio;
  late Duration _duration;
  late Duration _position;

  // New properties for loading and error handling

  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = "";
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;

  SongProvider({required this.songRemoteUsecase}) {
    _audioPlayer = AudioPlayer();
    _songs = [];
    _currentSong = null;
    _isPlaying = false;
    _audioFilePath = '';
    _hasFetchedAudio = false;
    _isFetchingAudio = false;
    _duration = const Duration(seconds: 0);
    _position = const Duration(seconds: 0);

    _audioPlayer.onDurationChanged.listen((Duration d) {
      _duration = d;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      _position = p;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      _position = _duration;
      notifyListeners();
    });
  }

  List<Song> get songs => _songs;
  bool get isPlaying => _isPlaying;
  Duration? get duration => _duration;
  Duration? get position => _position;
  Song? get currentSong => _currentSong;
  bool get hasFetchedAudio => _hasFetchedAudio;
  bool get isFetchingAudio => _isFetchingAudio;

  final int _initialFetchLimit =
      kIsWeb ? 8 : 4; // Initial number of songs to fetch
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  Future<List<Song>> fetchSongs() async {
    try {
      _isLoading = true;
      List<Song> newSongs =
          await songRemoteUsecase.fetchSongs(limit: _initialFetchLimit);
      _songs.addAll(newSongs);
      _isLoading = false;
      _hasMore = newSongs.isNotEmpty;
      notifyListeners();
      print("length${_songs.length}");
      return _songs; // Return the full list of songs
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      notifyListeners();
      print('Failed to fetch songs: $e');
      rethrow;
    }
  }

  //future use - show downloading percentage  of song

  // Future<String> fetchAndSaveAudio(String songUrl, String songId) async {
  //   String filePath = '${(await getTemporaryDirectory()).path}/$songId.mp3';
  //   File file = File(filePath);

  //   if (await file.exists()) {
  //     _hasFetchedAudio = true;
  //     notifyListeners();
  //     return filePath;
  //   }

  //   try {
  //     String downloadUrl = await getDownloadUrl(songUrl);
  //     final request = await HttpClient().getUrl(Uri.parse(downloadUrl));
  //     final response = await request.close();

  //     int totalBytes = response.contentLength; // Get total file size
  //     Stream<List<int>> stream = response.asBroadcastStream(); // Create stream
  //     int downloadedBytes = 0;

  //     stream.listen((data) {
  //       downloadedBytes += data.length;
  //       double percentage =
  //           (downloadedBytes / totalBytes) * 100; // Use double for percentage
  //       print(
  //           'Downloading $songId: $downloadedBytes of $totalBytes bytes - $percentage%'); // Print progress
  //     }, onDone: () {
  //       print('File downloaded successfully!');
  //     }, onError: (error) {
  //       // Handle errors if needed
  //     });
  //     response.pipe(file.openWrite()); // Pipe the stream directly
  //     _hasFetchedAudio = true;
  //     notifyListeners();
  //     return filePath;
  //   } catch (e) {
  //     throw Exception('Error fetching and saving audio stream: $e');
  //   }
  // }

  String sanitizeFileName(String fileName) {
    return fileName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
  }

  Future<String> fetchAndSaveAudio(String songUrl, String songId) async {
    String sanitizedSongId = sanitizeFileName(songId);
    String filePath =
        '${(await getTemporaryDirectory()).path}/$sanitizedSongId.mp3';

    File file = File(filePath);

    if (await file.exists()) {
      _hasFetchedAudio = true;
      notifyListeners();
      return filePath;
    }

    try {
      String downloadUrl = await getDownloadUrl(songUrl);
      final request = await HttpClient().getUrl(Uri.parse(downloadUrl));
      final response = await request.close();

      if (response.statusCode == 200) {
        await response.pipe(file.openWrite());
        _hasFetchedAudio = true;
        notifyListeners();
        return filePath;
      } else {
        throw Exception(
            'Error downloading file: HTTP status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching and saving audio stream: $e');
    }
  }

  Future<String> getDownloadUrl(String storageLocation) async {
    try {
      Reference ref = FirebaseStorage.instance.refFromURL(storageLocation);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error getting download URL: $e');
    }
  }

  void playAudio(Song song) async {
    // If a different song is requested, stop the current one
    if (_currentSong != null && _currentSong?.title != song.title) {
      await _audioPlayer.stop();
      _isPlaying = false;
    }

    // Handle new song or song change
    if (_currentSong?.title != song.title || !_hasFetchedAudio) {
      print("New song detected or audio not fetched. Fetching audio...");
      _isFetchingAudio = true;
      _currentSong = song;
      _hasFetchedAudio = false;
      notifyListeners();

      String downloadableUrl;
      try {
        // Fetch the downloadable URL from the storage location
        downloadableUrl = await getDownloadUrl(song.songUrl);
        print("Downloadable URL fetched: $downloadableUrl");
      } catch (e) {
        _isFetchingAudio = false;
        print("Error fetching downloadable URL: $e");
        return; // Exit early if fetching fails
      }

      _audioFilePath = downloadableUrl;

      // Handle mobile and web platforms differently
      if (kIsWeb) {
        // Web platform: Use downloadable URL directly
        print("Playing audio on Web...");
      } else {
        // Mobile platform: Fetch and save audio file
        try {
          _audioFilePath = await fetchAndSaveAudio(downloadableUrl, song.title);
          print("Audio fetched on Mobile: $_audioFilePath");
        } catch (e) {
          _isFetchingAudio = false;
          print("Error fetching audio on Mobile: $e");
          return; // Exit early if fetching fails
        }
      }
    }

    // Play audio
    if (_audioFilePath != null) {
      print("Playing audio...");
      _hasFetchedAudio = true;
      _isFetchingAudio = false;

      notifyListeners();
      await Future.delayed(
          const Duration(milliseconds: 500)); // Adjust delay as needed
      var decodedPath = Uri.decodeFull(_audioFilePath);
      _audioPlayer.play(UrlSource(decodedPath));
      _isPlaying = true;
    } else {
      print("Error: No audio path available");
    }

    _isFetchingAudio = false;
    notifyListeners();
  }

  void togglePlayPause() {
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(_audioFilePath));
    }
    _isPlaying = !_isPlaying;
    notifyListeners();
  }

  void seek(Duration position) {
    _audioPlayer.seek(position);
    notifyListeners();
  }
}
