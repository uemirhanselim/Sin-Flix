import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';
import '../models/register_request_model.dart';
import '../models/register_response_model.dart';

part 'auth_remote_data_source.g.dart';

@RestApi(baseUrl: "https://caseapi.servicelabs.tech/")
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @POST("user/register")
  Future<RegisterResponseModel> register(@Body() RegisterRequestModel request);

  @POST("user/login")
  Future<LoginResponseModel> login(@Body() LoginRequestModel request);
}

abstract class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterRequestModel request);
  Future<LoginResponseModel> login(LoginRequestModel request);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiService _apiService;

  AuthRemoteDataSourceImpl(this._apiService);

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _apiService.register(request);
      if (response.response.code != 200) {
        throw Exception(response.response.message);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _apiService.login(request);
      if (response.response.code != 200) {
        throw Exception(response.response.message);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}