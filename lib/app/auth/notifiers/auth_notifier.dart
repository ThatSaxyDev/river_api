// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_api/app/auth/controllers/auth_controller.dart';
import 'package:river_api/app/auth/providers/auth_providers.dart';
import 'package:river_api/app/home/views/home_view.dart';
import 'package:river_api/models/user_model.dart';
import 'package:river_api/shared/extensions.dart';
import 'package:river_api/shared/failure.dart';
import 'package:river_api/shared/regex.dart';

class AuthNotifier extends Notifier<AuthState> {
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
    if (!AppRegEx.regexEmail.hasMatch(email)) {
      showSnackBar(
        context: context,
        message: 'Email is invalid',
        type: NotificationType.failure,
      );
      return;
    }

    if (password.isEmpty) {
      showSnackBar(
        context: context,
        message: 'Password needed',
        type: NotificationType.failure,
      );
      return;
    }

    startLoading();

    await _authController.login(
      password: password,
      email: email,
      onError: (Failure error) {
        stopLoading();
        showSnackBar(
          context: context,
          message: error.message,
          type: NotificationType.failure,
        );
      },
      onSuccess: () {
        stopLoading();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const HomeView(),
        ));
        showSnackBar(
          context: context,
          message: 'Logged in successfully',
          type: NotificationType.success,
        );
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

void showSnackBar({
  required BuildContext context,
  required String message,
  required NotificationType type,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: switch (type) {
        NotificationType.success => const Color.fromARGB(255, 50, 125, 89),
        NotificationType.failure => Colors.redAccent,
      },
    ),
  );
}

enum NotificationType {
  success,
  failure,
}
