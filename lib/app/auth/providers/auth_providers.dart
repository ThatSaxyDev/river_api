import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_api/app/auth/controllers/auth_controller.dart';
import 'package:river_api/app/auth/notifiers/auth_state_notifier.dart';
import 'package:river_api/app/auth/notifiers/user_data_notifier.dart';
import 'package:river_api/app/auth/repo/auth_repository.dart';
import 'package:river_api/models/user_model.dart';
import 'package:river_api/services/dio/dio.dart';

//! the auth repo provider
final Provider<AuthRepository> authRepositoryProvider = Provider(
    (ref) => AuthRepository(ref: ref, dioClient: ref.watch(dioClientProvider)));


//! the auth controller provider
final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    ref: ref,
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

//! the auth state provider
final authStateNotifierProvider =
    NotifierProvider<AuthStateNotifier, AuthState>(() {
  return AuthStateNotifier();
});

//! the user data controller provider
final StateNotifierProvider<UserDataNotifier, UserModel?>
    userDataNotifierProvider = StateNotifierProvider(
  (ref) => UserDataNotifier(userDataNotifierRef: ref),
);