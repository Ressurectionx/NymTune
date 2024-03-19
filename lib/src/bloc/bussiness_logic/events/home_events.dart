import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LoadSongs extends HomeEvent {}

class FavoriteSong extends HomeEvent {
  final String songId;

  const FavoriteSong(this.songId);

  @override
  List<Object> get props => [songId];
}
