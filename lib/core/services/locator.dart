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
import 'logger_service.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // External
  locator.registerLazySingleton(() {
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final secureStorage = locator<FlutterSecureStorage>();
        final token = await secureStorage.read(key: 'token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
    return dio;
  });
  locator.registerLazySingleton(() => const FlutterSecureStorage());
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  // Services
  locator.registerLazySingleton<LoggerService>(() => LoggerServiceImpl());
  locator.registerLazySingleton(() => AuthApiService(locator()));
  locator.registerLazySingleton(() => UserApiService(locator()));

  // Data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(locator()),
  );
  locator.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(locator()),
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

  // Use cases
  locator.registerLazySingleton(() => RegisterUser(locator()));
  locator.registerLazySingleton(() => LoginUser(locator()));
  locator.registerLazySingleton(() => UploadUserPhoto(locator()));

  // Blocs
  locator.registerFactory(() => ProfileDetailBloc(uploadUserPhoto: locator<UploadUserPhoto>()));
}
 