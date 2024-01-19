import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../core/model/general_list_model.dart';
import '../core/model/login_model.dart';
import '../core/model/parameters_model.dart';

enum mySharedKey {
  // ignore: constant_identifier_names
  TKP_COMPANY_NAME,
  // ignore: constant_identifier_names
  TKP_SERVICE_URL,
  // ignore: constant_identifier_names
  TKP_COMPANY_LOGO,
  // ignore: constant_identifier_names
  TKP_LICENCE,
  // ignore: constant_identifier_names
  TKP_USER_DATA,
  // ignore: constant_identifier_names
  TKP_USER_NAME,
  // ignore: constant_identifier_names
  TKP_RECORD_COUNT,
  // ignore: constant_identifier_names
  TKP_GLOBAL_FILTER_PRICE_LIST,
  // ignore: constant_identifier_names
  TKP_GLOBAL_FILTER_WAREHOUSE,
  // ignore: constant_identifier_names
  TKP_GLOBAL_FILTER_CATEGORY,
  // ignore: constant_identifier_names
  TKP_GLOBAL_FILTER_ATTRIBUTES,
  // ignore: constant_identifier_names
<<<<<<< Updated upstream
  TKP_ASPECT_RATIO,
=======
  TKP_UPLOAD_MODULE_ACTIVE
>>>>>>> Stashed changes
}

class MySharedPreferences {
  MySharedPreferences._privateConstructor();

  static final MySharedPreferences instance =
      MySharedPreferences._privateConstructor();

  Future<void> setLoggedInUserData(LoginModelData? user) async {
    print(user?.toJson());
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    String? encodedData = user == null ? "" : jsonEncode(user.toJson());

    await prefs.setString(mySharedKey.TKP_USER_DATA.name, encodedData);

    await prefs.setString(
        mySharedKey.TKP_COMPANY_NAME.name, user?.companyName ?? '');

    await prefs.setString(mySharedKey.TKP_USER_NAME.name, user?.userName ?? '');
    await prefs.setString(
        mySharedKey.TKP_SERVICE_URL.name, user?.serviceURL ?? '');
    await prefs.setString(
        mySharedKey.TKP_COMPANY_LOGO.name, user?.companyLogo ?? '');
    await prefs.setBool(
        mySharedKey.TKP_LICENCE.name, user?.isActive == 1 ? true : false);
    await prefs.setInt(
        mySharedKey.TKP_UPLOAD_MODULE_ACTIVE.name, user?.uploadModule ?? 0);
  }

  Future<void> setGlobalFilterModel(
      List<GeneralListType>? data, mySharedKey key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? encodedData = data == null ? "" : jsonEncode(data);
    await myPrefs.setString(key.name, encodedData);
  }

  Future<void> setAttributes(
      List<AttributesModel>? data, mySharedKey key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? encodedData = data == null ? "" : jsonEncode(data);
    await myPrefs.setString(key.name, encodedData);
  }

  Future<List<GeneralListType>?> getGlobalFilterModel(mySharedKey key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? encodedData = myPrefs.getString(key.name);
    if (encodedData != null && encodedData.isNotEmpty) {
      List<dynamic> decodedData = jsonDecode(encodedData);
      List<GeneralListType> data = decodedData
          .map((dynamic item) => GeneralListType.fromJson(item))
          .toList();
      return data;
    } else {
      return [];
    }
  }

  Future<List<AttributesModel>?> getAttributes(mySharedKey key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    String? encodedData = myPrefs.getString(key.name);
    if (encodedData != null && encodedData.isNotEmpty) {
      List<dynamic> decodedData = jsonDecode(encodedData);
      List<AttributesModel> data = decodedData
          .map((dynamic item) => AttributesModel.fromJson(item))
          .toList();
      return data;
    } else {
      return [];
    }
  }

  Future<String?> getStringValue(mySharedKey key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getString(key.name) ?? '';
  }

  Future<bool?> getBoolValue(mySharedKey key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key.name) ?? false;
  }

  Future<int?> getIntValue(mySharedKey key) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getInt(key.name) ?? 0;
  }

  Future<void> setIntValue(mySharedKey key, int value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    await myPrefs.setInt(key.name, value);
  }

  Future<void> removeUserLogout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> setSAspectRatio(double value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    await myPrefs.setDouble(mySharedKey.TKP_ASPECT_RATIO.name, value);
  }

  Future<double?> getAspectRatio() async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getDouble(mySharedKey.TKP_ASPECT_RATIO.name) ?? 1 / 1;
  }
}
