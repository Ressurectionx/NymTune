import 'package:flutter/material.dart';

import '../data/models/song_model.dart';

import '../data/usecases/search_usecase.dart';

class SearchProvider extends ChangeNotifier {
  final SearchSongsUseCase searchSongsUseCase;
  final List<Song> _searchResults = [];
  final TextEditingController searchController =
      TextEditingController(); // Add controller for text field

  SearchProvider(this.searchSongsUseCase) {
    _callSearchSongs(""); // Initial empty search
  }

  searchSongs(String searchTerm) async {
    if (searchTerm.isEmpty) {
      _searchResults.clear();
      notifyListeners();
    } else {
      final result = await searchSongsUseCase.searchSongs(searchTerm);
      result.fold(
        (failure) => print('Error searching songs: ${failure.message}'),
        (songs) {
          _searchResults.clear();
          _searchResults.addAll(songs);
        },
      );
      notifyListeners();
    }
  }

  // Updated for initial empty search
  void _callSearchSongs(String searchTerm) async {
    await searchSongs(searchTerm); // Perform initial search
  }

  List<Song> get searchResults => _searchResults;
}
