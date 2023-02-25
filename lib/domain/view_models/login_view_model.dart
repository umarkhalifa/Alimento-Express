import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping/core/controllers/request_view_model.dart';
import 'package:grocery_shopping/domain/auth_dm/auth_data_manager.dart';

class LoginViewModel extends RequestStateNotifier {
  final AuthDataManager authDataManager;

  LoginViewModel({required this.authDataManager});

  void login({required String email, required String password}) {
    makeRequest(
      () => authDataManager.login(email: email, password: password),
    );
  }
}

final loginVMProvider = StateNotifierProvider<LoginViewModel, RequestState>(
  (ref) => LoginViewModel(
    authDataManager: ref.read(authDMProvider),
  ),
);
