import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_api/models/user_model.dart';

class UserDataNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() {
    return null;
  }

  Future<bool?> get isAlreadyLoggedIn async => state != null;

  Future<void> setUserData({required UserModel currentPayload}) async =>
      state = currentPayload;

  Future<void> removeUserData() async {
    // await SecureStorage.instance.delete(key: Tokens.atck.name);
    // await SecureStorage.instance.delete(key: Tokens.rfkt.name);
    state = null;
  }

  UserModel? get user => state;
}
