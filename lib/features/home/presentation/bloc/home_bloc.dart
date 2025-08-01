import 'package:dating_app/features/movie/domain/entities/movie_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/services/logger_service.dart';
import '../../../movie/domain/usecases/get_movie_list.dart';
import '../../../movie/domain/usecases/toggle_favorite.dart'; // Yeni import
import 'home_event.dart';
import 'home_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMovieList getMovieList;
  final LoggerService logger;
  final FlutterSecureStorage secureStorage;
  final ToggleFavorite toggleFavorite; // Yeni bağımlılık

  int _currentPage = 1;
  bool _hasReachedMax = false;

  HomeBloc({
    required this.getMovieList,
    required this.logger,
    required this.secureStorage,
    required this.toggleFavorite, // Yeni bağımlılık
  }) : super(HomeInitial()) {
    on<CheckAuthToken>(_onCheckAuthToken);
    on<GetMoviesEvent>(_onGetMoviesEvent, transformer: droppable());
    on<LoadMoreMovies>(_onLoadMoreMovies, transformer: droppable());
    on<ToggleFavoriteEvent>(_onToggleFavoriteEvent); // Yeni olay işleyici
  }

  Future<void> _onCheckAuthToken(CheckAuthToken event, Emitter<HomeState> emit) async {
    final token = await secureStorage.read(key: 'token');
    logger.i('Token from secure storage: $token');
  }

  Future<void> _onGetMoviesEvent(GetMoviesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    _currentPage = 1;
    _hasReachedMax = false;
    final result = await getMovieList(GetMovieListParams(page: _currentPage));

    result.fold(
      (failure) {
        logger.e('Failed to get movie list', failure.message);
        emit(HomeError(message: failure.message));
      },
      (movies) {
        logger.i('Movie list fetched successfully for page $_currentPage');
        emit(HomeLoaded(movies: movies, hasReachedMax: movies.isEmpty));
      },
    );
  }

  Future<void> _onLoadMoreMovies(LoadMoreMovies event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded && !(state as HomeLoaded).hasReachedMax) {
      final currentState = state as HomeLoaded;
      _currentPage++;
      final result = await getMovieList(GetMovieListParams(page: _currentPage));

      result.fold(
        (failure) {
          logger.e('Failed to load more movies', failure.message);
          // Optionally emit an error state for loading more
        },
        (newMovies) {
          if (newMovies.isEmpty) {
            _hasReachedMax = true;
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            emit(currentState.copyWith(
              movies: List.of(currentState.movies)..addAll(newMovies),
              hasReachedMax: false,
            ));
          }
        },
      );
    }
  }

  Future<void> _onToggleFavoriteEvent(ToggleFavoriteEvent event, Emitter<HomeState> emit) async {
    if (state is HomeLoaded) {
      final currentState = state as HomeLoaded;
      final updatedMovies = List<MovieEntity>.from(currentState.movies);
      final movieIndex = updatedMovies.indexWhere((movie) => movie.id == event.movieId);

      if (movieIndex != -1) {
        final oldMovie = updatedMovies[movieIndex];
        final newMovie = oldMovie.copyWith(isFavorite: !oldMovie.isFavorite); // isFavorite'i tersine çevir
        updatedMovies[movieIndex] = newMovie;

        // Optimistic UI Update
        emit(currentState.copyWith(movies: updatedMovies));

        final result = await toggleFavorite(ToggleFavoriteParams(movieId: event.movieId, isFavorite: newMovie.isFavorite));

        result.fold(
          (failure) {
            logger.e('Failed to toggle favorite for movie ${event.movieId}', failure.message);
            // API hatası durumunda UI'ı geri al
            updatedMovies[movieIndex] = oldMovie; // Eski durumu geri yükle
            emit(currentState.copyWith(movies: updatedMovies));
            // Kullanıcıya hata mesajı gösterebiliriz
          },
          (_) {
            logger.i('Favorite toggled successfully for movie ${event.movieId}');
            // Başarılı, UI zaten güncellendi
          },
        );
      }
    }
  }
}
