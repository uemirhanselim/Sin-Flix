import 'package:equatable/equatable.dart';
import '../../../movie/domain/entities/movie_entity.dart';

abstract class FavoriteMoviesState extends Equatable {
  const FavoriteMoviesState();

  @override
  List<Object?> get props => [];
}

class FavoriteMoviesInitial extends FavoriteMoviesState {}

class FavoriteMoviesLoading extends FavoriteMoviesState {}

class FavoriteMoviesLoaded extends FavoriteMoviesState {
  final List<MovieEntity> movies;

  const FavoriteMoviesLoaded({required this.movies});

  @override
  List<Object> get props => [movies];
}

class FavoriteMoviesError extends FavoriteMoviesState {
  final String message;

  const FavoriteMoviesError({required this.message});

  @override
  List<Object> get props => [message];
}
