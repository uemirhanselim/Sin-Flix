import 'package:equatable/equatable.dart';
import '../../../movie/domain/entities/movie_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<MovieEntity> movies;
  final bool hasReachedMax;

  const HomeLoaded({this.movies = const [], this.hasReachedMax = false});

  HomeLoaded copyWith({
    List<MovieEntity>? movies,
    bool? hasReachedMax,
  }) {
    return HomeLoaded(
      movies: movies ?? this.movies,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [movies, hasReachedMax];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}
