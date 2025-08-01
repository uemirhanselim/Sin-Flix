import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class CheckAuthToken extends HomeEvent {}

class GetMoviesEvent extends HomeEvent {
  const GetMoviesEvent();
}

class LoadMoreMovies extends HomeEvent {}

class ToggleFavoriteEvent extends HomeEvent {
  final String movieId;

  const ToggleFavoriteEvent({required this.movieId});

  @override
  List<Object> get props => [movieId];
}
