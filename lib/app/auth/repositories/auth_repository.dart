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

  //! simulate login
  FutureEither<UserModel> simulateLogin({
    required String password,
    required String email,
  }) async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      // simulating a successful response
      final Map<String, dynamic> responseInMap = email == 'a@mail.com'
          ? {
              "status": "success",
              "data": {
                "user": {
                  "id": 1,
                  "name": "John Doe",
                  "email": email,
                },
                "token": "sample_token"
              }
            }
          : {
              "status": "failure",
              "message": "Incorrect email or password",
            };

      if (responseInMap["status"] == 'success') {
        responseInMap.log();
        'login here'.log();

        UserModel user = UserModel.fromMap(responseInMap["data"]["user"]);

        user.toString().log();

        // String token = responseInMap["data"]["token"];
        // await SecureStorage.instance.write(key: Tokens.atck.name, value: token);

        return right(user);
      } else {
        "login Response Failure: $responseInMap".log();
        return left(Failure(responseInMap["message"]));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //! GET USERS
  Future<List<UserModel>> fetchUsers() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulate a response with a list of users
    final List<Map<String, dynamic>> responseInMap = [
      {
        "id": 1,
        "name": "John Doe",
        "email": "john.doe@example.com",
      },
      {
        "id": 2,
        "name": "Jane Smith",
        "email": "jane.smith@example.com",
      },
      {
        "id": 3,
        "name": "Alice Johnson",
        "email": "alice.johnson@example.com",
      }
    ];

    // Convert the list of maps into a list of UserModel objects
    List<UserModel> users =
        responseInMap.map((userMap) => UserModel.fromMap(userMap)).toList();

    return users;
  }
}
