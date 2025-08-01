import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../auth/data/models/upload_photo_response_model.dart';
import '../models/user_profile_response_model.dart'; // Yeni import

part 'user_remote_data_source.g.dart';

@RestApi(baseUrl: "https://caseapi.servicelabs.tech/")
abstract class UserApiService {
  factory UserApiService(Dio dio, {String baseUrl}) = _UserApiService;

  @POST("user/upload_photo")
  @MultiPart()
  Future<UploadPhotoResponseModel> uploadPhoto(@Body() FormData photo);

  @GET("/user/profile")
  Future<UserProfileResponseModel> getUserProfile();
}

abstract class UserRemoteDataSource {
  Future<UploadPhotoResponseModel> uploadPhoto(FormData photo);
  Future<UserProfileResponseModel> getUserProfile();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final UserApiService _apiService;

  UserRemoteDataSourceImpl(this._apiService);

  @override
  Future<UploadPhotoResponseModel> uploadPhoto(FormData photo) async {
    try {
      final response = await _apiService.uploadPhoto(photo);
      if (response.response.code != 200) {
        throw Exception(response.response.message);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserProfileResponseModel> getUserProfile() async {
    try {
      final response = await _apiService.getUserProfile();
      if (response.response.code != 200) {
        throw Exception(response.response.message);
      }
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
