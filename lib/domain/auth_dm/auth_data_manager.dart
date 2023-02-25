import 'package:grocery_shopping/data/auth_data_source.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

abstract class AuthImplementation {
  Future<void> login({required String email, required String password});

  Future<void> signUp(
      {required String email, required String password, required String name});

  Future<void> updateInfo(String? password, String? name);
}

class AuthDataManager extends AuthImplementation {
  final AuthService authService;

  AuthDataManager({required this.authService});

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      await authService.signIn(email: email, password: password);
    } catch (error) {
      throw error.toString();
    }
  }

  @override
  Future<void> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      await authService.signUp(
          email: email, password: password, name: name, userName: name);
    } catch (error) {
      throw error.toString();
    }
  }

  @override
  Future<void> updateInfo(String? password, String? name)async {
    try{
      await authService.updateInfo(name, password);
    }catch (error){
      throw error.toString();
    }
  }
}

final authDMProvider = Provider(
  (ref) => AuthDataManager(
    authService: ref.read(authServiceProvider),
  ),
);
