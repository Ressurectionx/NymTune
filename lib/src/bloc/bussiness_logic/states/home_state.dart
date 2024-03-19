// states.dart

import 'package:equatable/equatable.dart';

import '../../data/models/song_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class SongsLoaded extends HomeState {
  final List<Song> songs;

  const SongsLoaded(this.songs);

  @override
  List<Object> get props => [songs];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
