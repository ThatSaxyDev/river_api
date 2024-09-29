import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:river_api/app/auth/repositories/auth_repository.dart';
import 'package:river_api/models/user_model.dart';
import 'package:river_api/shared/failure.dart';

import '../providers/auth_providers.dart';

class AuthController {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  })  : _authRepository = authRepository,
        _ref = ref;

  //! login
  Future<void> login({
    required String password,
    required String email,
    required void Function(Failure) onError,
    required void Function() onSuccess,
  }) async {
    Either<Failure, UserModel> res = await _authRepository.simulateLogin(
      password: password,
      email: email,
    );

    res.fold(
      (Failure error) => onError(error),
      (UserModel user) {
        _ref
            .read(userDataNotifierProvider.notifier)
            .setUserData(currentPayload: user);
        onSuccess();
      },
    );
  }
}
