import 'package:dating_app/core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/logger_service.dart';
import '../../../movie/domain/usecases/get_favorite_movies.dart';
import 'favorite_movies_event.dart';
import 'favorite_movies_state.dart';

class FavoriteMoviesBloc extends Bloc<FavoriteMoviesEvent, FavoriteMoviesState> {
  final GetFavoriteMovies getFavoriteMovies;
  final LoggerService logger;

  FavoriteMoviesBloc({
    required this.getFavoriteMovies,
    required this.logger,
  }) : super(FavoriteMoviesInitial()) {
    on<GetFavoriteMoviesEvent>(_onGetFavoriteMoviesEvent);
  }

  Future<void> _onGetFavoriteMoviesEvent(GetFavoriteMoviesEvent event, Emitter<FavoriteMoviesState> emit) async {
    emit(FavoriteMoviesLoading());
    final result = await getFavoriteMovies(NoParams());

    result.fold(
      (failure) {
        logger.e('Failed to get favorite movie list', failure.message);
        emit(FavoriteMoviesError(message: failure.message));
      },
      (movies) {
        logger.i('Favorite movie list fetched successfully');
        emit(FavoriteMoviesLoaded(movies: movies));
      },
    );
  }
}
