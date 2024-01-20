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
  AuthController? authController;
  AuthStateNotifier();

  @override
  AuthState build() {
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

    state = state.copyWith(email: email);

    authController = ref.read(authControllerProvider.notifier);

    if (authController != null) {
      await authController!.login(
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
}

//! state
class AuthState {
  final String firstName;
  final String lastName;
  final bool isLoading;
  final String username;
  final String password;
  final String email;
  final String fullName;
  final String companyName;
  final String companyRole;
  final int companySize;
  final String industry;

  const AuthState({
    this.firstName = '',
    this.lastName = '',
    this.isLoading = false,
    this.username = '',
    this.password = '',
    this.email = '',
    this.fullName = '',
    this.companyName = '',
    this.companyRole = '',
    this.companySize = 0,
    this.industry = '',
  });

  AuthState copyWith({
    String? firstName,
    String? lastName,
    bool? isLoading,
    String? username,
    String? password,
    String? email,
    String? fullName,
    String? companyName,
    String? companyRole,
    int? companySize,
    String? industry,
  }) {
    return AuthState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      isLoading: isLoading ?? this.isLoading,
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      companyName: companyName ?? this.companyName,
      companyRole: companyRole ?? this.companyRole,
      companySize: companySize ?? this.companySize,
      industry: industry ?? this.industry,
    );
  }
}
