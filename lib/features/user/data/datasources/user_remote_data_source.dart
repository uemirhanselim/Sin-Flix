import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../auth/data/models/upload_photo_response_model.dart';

part 'user_remote_data_source.g.dart';

@RestApi(baseUrl: "https://caseapi.servicelabs.tech/")
abstract class UserApiService {
  factory UserApiService(Dio dio, {String baseUrl}) = _UserApiService;

  @POST("user/upload_photo")
  @MultiPart()
  Future<UploadPhotoResponseModel> uploadPhoto(@Body() FormData photo);
}

abstract class UserRemoteDataSource {
  Future<UploadPhotoResponseModel> uploadPhoto(FormData photo);
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
}
