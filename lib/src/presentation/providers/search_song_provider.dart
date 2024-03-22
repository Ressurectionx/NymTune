import 'package:flutter/material.dart';

import '../data/models/song_model.dart';

class SearchProvider extends ChangeNotifier {
  final Future<List<Song>> songListFuture;
  final TextEditingController searchController = TextEditingController();
  final List<Song> _allSongs = [];
  List<Song> _searchResults = [];

  SearchProvider(this.songListFuture) {
    songListFuture.then((songs) {
      _allSongs.addAll(songs);
      _searchResults = _allSongs;
      notifyListeners();
    });

    searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    final searchTerm = searchController.text.toLowerCase();
    if (searchTerm.isEmpty) {
      _searchResults = _allSongs;
    } else {
      _searchResults = _allSongs
          .where((song) => song.title.toLowerCase().contains(searchTerm))
          .toList();
    }
    notifyListeners();
  }

  List<Song> get searchResults => _searchResults;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
