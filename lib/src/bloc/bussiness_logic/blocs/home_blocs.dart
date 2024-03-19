// home_bloc.dart

import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../data/models/song_model.dart';
import '../../data/repositories/fetch_song_repo.dart';
import '../events/home_events.dart';
import '../states/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final SongRepository? songRepository;

  HomeBloc({this.songRepository}) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is LoadSongs) {
      yield* _mapLoadSongsToState();
    } else if (event is FavoriteSong) {
      yield* _mapFavoriteSongToState(event);
    }
  }

  Stream<HomeState> _mapLoadSongsToState() async* {
    try {
      final List<Song> songs = await songRepository!.fetchSongs();
      yield SongsLoaded(songs);
    } catch (e) {
      yield HomeError("Failed to load songs.");
    }
  }

  Stream<HomeState> _mapFavoriteSongToState(FavoriteSong event) async* {
    // Logic to favorite a song and update the UI
    // You might want to call your repository method here to handle favoriting the song
    // Ensure to update the state accordingly based on the success or failure of the operation
  }
}
