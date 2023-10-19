import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/model/app_api_status_model.dart';
import '../../service/network_manager.dart';
import '../../service/shared_preferences.dart';

final loginFormProvider = ChangeNotifierProvider<LoginFormProvider>((ref) {
  return LoginFormProvider();
});

class LoginFormProvider extends ChangeNotifier {
  final NetworkManager _networkManager = NetworkManager();

  bool _isObscure = true;
  String _username = '';
  String _password = '';

  bool get isObscure => _isObscure;
  String get username => _username;
  String get password => _password;

  void changeObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  void setUsername(String value) {
    _username = value;
  }

  void setPassword(String value) {
    _password = value;
  }

  void setDemoLogin() {
    _username = 'demo';
    _password = 'demo1234';
    notifyListeners();
  }

  Future<AppApiStatusModel?> submitLoginForm() async {
    if (!isValidUsername()) {
      return AppApiStatusModel(
          message: "Geçersiz Kullanıcı Adı", result: false);
    }
    if (_password.length < 6 || _password.isEmpty) {
      return AppApiStatusModel(
          message: "Şifreniz en az 6 karakter olmalıdır.", result: false);
    }

    try {
      var response = await _networkManager.loginUser(
          username: _username, password: _password);

      if (response != null) {
        if (response.state == true) {
          // user login data
          await MySharedPreferences.instance
              .setLoggedInUserData(response.data?.first);
          // price lists
          await MySharedPreferences.instance.setGlobalFilterModel(
              response.prices, mySharedKey.TKP_GLOBAL_FILTER_PRICE_LIST);
          // warehouses
          await MySharedPreferences.instance.setGlobalFilterModel(
              response.warehouseList, mySharedKey.TKP_GLOBAL_FILTER_WAREHOUSE);
          // categories
          await MySharedPreferences.instance.setGlobalFilterModel(
              response.categories, mySharedKey.TKP_GLOBAL_FILTER_CATEGORY);
          // attributes
          await MySharedPreferences.instance.setAttributes(
              response.attributes, mySharedKey.TKP_GLOBAL_FILTER_ATTRIBUTES);

          // return success
          return AppApiStatusModel(message: response.message, result: true);
        }
        return AppApiStatusModel(message: response.message, result: false);
      }
    } catch (e) {
      return AppApiStatusModel(
          message: "Daha sonra tekrar deneyiniz.", result: false);
    }
    return null;
  }

  bool isValidUsername() {
    if (_username.isEmpty) {
      return false;
    }
    RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
    if (regex.hasMatch(_username)) {
      return true;
    }
    return false;
  }
}
