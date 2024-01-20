import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:river_api/models/user_model.dart';
import 'package:river_api/services/dio/dio.dart';
import 'package:river_api/services/dio/exceptions.dart';
import 'package:river_api/services/secure_storage/secure_storage.dart';
import 'package:river_api/shared/app_urls.dart';
import 'package:river_api/shared/extensions.dart';
import 'package:river_api/shared/failure.dart';
import 'package:river_api/shared/type_defs.dart';

class AuthRepository {
  final DioClient _dioClient;
  final Ref _ref;
  const AuthRepository({
    required DioClient dioClient,
    required Ref ref,
  })  : _dioClient = dioClient,
        _ref = ref,
        super();

  //! login
  FutureEither<UserModel> login({
    required String password,
    required String email,
  }) async {
    try {
      //! MAKE REQUEST
      final Map<String, dynamic> responseInMap = await _dioClient.post(
        path: AppUrls.login,
        payload: {
          "password": password,
          "email": email,
        },
      );

      if (responseInMap["status"] == 'success') {
        responseInMap.log();
        'login here'.log();
        UserModel? user;

        // UserModel user = UserModel.fromMap(responseInMap["data"]["user"]);

        // user.toString().log();

        // String token = responseInMap["data"]["token"];

        // //! save token
        // await SecureStorage.instance.write(key: Tokens.atck.name, value: token);
        return right(user!);
      } else {
        "login Response Failure: $responseInMap".log();

        return left(Failure(responseInMap["message"]));
      }
    } on DioException catch (exception) {
      final AppDioException error =
          AppDioException.fromDIOException(dioException: exception);

      return left(Failure(error.errorMessage));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
