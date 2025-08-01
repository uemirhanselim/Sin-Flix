import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/services/logger_service.dart';
import '../../../movie/domain/usecases/get_movie_list.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetMovieList getMovieList;
  final LoggerService logger;
  final FlutterSecureStorage secureStorage;

  HomeBloc({
    required this.getMovieList,
    required this.logger,
    required this.secureStorage,
  }) : super(HomeInitial()) {
    on<CheckAuthToken>(_onCheckAuthToken);
    on<GetMoviesEvent>(_onGetMoviesEvent);
  }

  Future<void> _onCheckAuthToken(CheckAuthToken event, Emitter<HomeState> emit) async {
    final token = await secureStorage.read(key: 'token');
    logger.i('Token from secure storage: $token');
  }

  Future<void> _onGetMoviesEvent(GetMoviesEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    final result = await getMovieList(GetMovieListParams(page: event.page));

    result.fold(
      (failure) {
        logger.e('Failed to get movie list', failure.message ?? '');
        emit(HomeError(message: failure.message));
      },
      (movies) {
        logger.i('Movie list fetched successfully');
        emit(HomeLoaded(movies: movies));
      },
    );
  }
}
