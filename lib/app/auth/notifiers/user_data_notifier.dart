import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_api/models/user_model.dart';

class UserDataNotifier extends StateNotifier<UserModel?> {
  UserDataNotifier({
    required this.userDataNotifierRef,
  }) : super(null);

  Ref userDataNotifierRef;

  Future<bool?> get isAlreadyLoggedIn async => state != null;

  Future<void> setUserData({required UserModel currentPayload}) async =>
      state = currentPayload;

  Future<void> removeUserData() async => state = null;

  UserModel? get user => state;
}
