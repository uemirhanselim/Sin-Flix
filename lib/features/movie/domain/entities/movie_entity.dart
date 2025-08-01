import 'package:equatable/equatable.dart';

class MovieEntity extends Equatable {
  final String id;
  final String title;
  final String year;
  final String poster;
  final String plot;
  final String genre;
  final List<String> images;
  final bool isFavorite;

  const MovieEntity({
    required this.id,
    required this.title,
    required this.year,
    required this.poster,
    required this.plot,
    required this.genre,
    required this.images,
    required this.isFavorite,
  });

  MovieEntity copyWith({
    String? id,
    String? title,
    String? year,
    String? poster,
    String? plot,
    String? genre,
    List<String>? images,
    bool? isFavorite,
  }) {
    return MovieEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      poster: poster ?? this.poster,
      plot: plot ?? this.plot,
      genre: genre ?? this.genre,
      images: images ?? this.images,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [id, title, year, poster, plot, genre, images, isFavorite];
}
