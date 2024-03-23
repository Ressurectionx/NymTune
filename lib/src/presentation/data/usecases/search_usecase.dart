import 'package:dartz/dartz.dart';

import '../models/song_model.dart';
import '../repositories/search_repo.dart';

class SearchSongsUseCase {
  final SearchRepository searchRepository;

  SearchSongsUseCase(this.searchRepository);

  Future<Either<Failure, List<Song>>> searchSongs(String searchTerm) async {
    try {
      final songs = await searchRepository.searchSongs(searchTerm);
      return Right(songs);
    } catch (e) {
      return Left(Failure(message: 'Error searching songs: $e'));
    }
  }
}

class Failure {
  final String message;
  Failure({required this.message});
}
