import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_api/app/auth/controllers/auth_controller.dart';
import 'package:river_api/app/auth/notifiers/auth_notifier.dart';
import 'package:river_api/app/auth/notifiers/user_data_notifier.dart';
import 'package:river_api/app/auth/repositories/auth_repository.dart';
import 'package:river_api/models/user_model.dart';
import 'package:river_api/services/dio/dio.dart';

//! the auth repo provider
final Provider<AuthRepository> authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    ref: ref,
    // dioClient: ref.watch(dioClientProvider),
  ),
);

//! the auth controller provider
final authControllerProvider = Provider(
  (ref) => AuthController(
    ref: ref,
    authRepository: ref.watch(authRepositoryProvider),
  ),
);

//! the auth state provider
final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

//! the user data notifier provider
final userDataNotifierProvider = NotifierProvider<UserDataNotifier, UserModel?>(
  () => UserDataNotifier(),
);

//! future providers
final fetchUserProvider = FutureProvider<List<UserModel>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return authRepository.fetchUsers();
});
