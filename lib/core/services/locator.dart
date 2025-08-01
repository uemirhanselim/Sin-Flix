import 'package:dating_app/features/home/presentation/bloc/home_bloc.dart';
import 'package:dating_app/features/profile/presentation/bloc/profile_detail_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/user/data/datasources/user_remote_data_source.dart';
import '../../features/user/data/repositories/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/user/domain/usecases/upload_user_photo.dart';
import '../../features/movie/data/datasources/movie_remote_data_source.dart';
import '../../features/movie/data/repositories/movie_repository_impl.dart';
import '../../features/movie/domain/repositories/movie_repository.dart';
import '../../features/movie/domain/usecases/get_movie_list.dart';
import 'logger_service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // External
  locator.registerLazySingleton(() {
    final dio = Dio(BaseOptions(contentType: "application/json"));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final secureStorage = locator<FlutterSecureStorage>();
        final token = await secureStorage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
          locator<LoggerService>().d('Request to ${options.path} with Authorization header: Bearer $token');
        } else {
          locator<LoggerService>().d('Request to ${options.path} without Authorization header.');
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        locator<LoggerService>().e('Dio Error: ${e.requestOptions.path}', e.message, e.stackTrace);
        if (e.response != null) {
          locator<LoggerService>().e('Dio Error Response Data: ${e.response?.data}');
        }
        return handler.next(e);
      },
    ));
    return dio;
  });
  locator.registerLazySingleton(() => const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  ));
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  // Services
  locator.registerLazySingleton<LoggerService>(() => LoggerServiceImpl());
  locator.registerLazySingleton(() => AuthApiService(locator()));
  locator.registerLazySingleton(() => UserApiService(locator()));
  locator.registerLazySingleton(() => MovieApiService(locator()));

  // Data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator()),
  );
  locator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(locator()),
  );
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(locator(), locator<LoggerService>()),
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: locator(),
      secureStorage: locator(),
      sharedPreferences: locator(),
    ),
  );
  locator.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      remoteDataSource: locator(),
      sharedPreferences: locator(),
    ),
  );
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(remoteDataSource: locator()),
  );

  // Use cases
  locator.registerLazySingleton(() => RegisterUser(locator()));
  locator.registerLazySingleton(() => LoginUser(locator()));
  locator.registerLazySingleton(() => UploadUserPhoto(locator()));
  locator.registerLazySingleton(() => GetMovieList(locator()));

  // Blocs
  locator.registerFactory(() => ProfileDetailBloc(uploadUserPhoto: locator<UploadUserPhoto>()));
  locator.registerFactory(() => HomeBloc(getMovieList: locator<GetMovieList>(), logger: locator<LoggerService>(), secureStorage: locator<FlutterSecureStorage>()));
}

 