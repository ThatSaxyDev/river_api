// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_api/app/auth/controllers/auth_controller.dart';
import 'package:river_api/app/auth/providers/auth_providers.dart';
import 'package:river_api/models/user_model.dart';
import 'package:river_api/shared/extensions.dart';
import 'package:river_api/shared/failure.dart';
import 'package:river_api/shared/regex.dart';

class AuthStateNotifier extends Notifier<AuthState> {
  late AuthController _authController;
  @override
  AuthState build() {
    _authController = ref.watch(authControllerProvider);
    return const AuthState();
  }

  void startLoading() {
    state = state.copyWith(isLoading: true);
  }

  void stopLoading() {
    state = state.copyWith(isLoading: false);
  }

  //! login  user
  void loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    startLoading();
    if (!AppRegEx.regexEmail.hasMatch(email)) {
      stopLoading();
      'Email is invalid'.log();
      return;
    }

    if (password.isEmpty) {
      stopLoading();
      'Password needed'.log();
      return;
    }

    await _authController.login(
      password: password,
      email: email,
      onError: (Failure error) {
        stopLoading();
        error.message.log();
      },
      onSuccess: () {
        stopLoading();
        'logged in'.log();
      },
    );
  }
}

//! state
class AuthState {
  final bool isLoading;

  const AuthState({
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isLoading,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
