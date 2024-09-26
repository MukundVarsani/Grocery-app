import 'package:flutter/foundation.dart';
import 'package:myshop/Model/user_model.dart';
import 'package:myshop/services/UserServices/user_services.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _userModel;
  UserServices? _userServices;
  UserProvider() {
    _userModel = UserModel();
    _userServices = UserServices();
  }

  UserModel? get getCurrentUser => _userModel;

  Future<void> setUser() async {
    _userModel = await _userServices?.getCurrentUserDetail();
    notifyListeners();
  }

  void deleteUser() {
    _userModel = UserModel();
    notifyListeners();
  }
}
