import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocery_shopping/core/controllers/request_view_model.dart';
import 'package:grocery_shopping/domain/auth_dm/auth_data_manager.dart';

class UpdateInfoViewModel extends RequestStateNotifier {
  final AuthDataManager authDataManager;

  UpdateInfoViewModel({required this.authDataManager});

  void updateInfo( String? name, String? password) {
    makeRequest(
          () => authDataManager.updateInfo(password, name),
    );
  }
}

final updateInfoVMProvider = StateNotifierProvider<UpdateInfoViewModel, RequestState>(
      (ref) => UpdateInfoViewModel(
    authDataManager: ref.read(authDMProvider),
  ),
);
