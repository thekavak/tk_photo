import 'package:tk_photo/core/model/parameters_model.dart';
import 'package:tk_photo/service/shared_preferences.dart';

import '../core/model/login_model.dart';
import 'package:dio/dio.dart';

import '../core/model/product_list_model.dart';

enum GetApiMethod {
  login,
  parameters,
  productQuery;

  String get value {
    switch (this) {
      case GetApiMethod.login:
        return 'login';
      case GetApiMethod.productQuery:
        return 'getProduct';
      case GetApiMethod.parameters:
        return 'getParams';
    }
  }

  String get method {
    return value;
  }
}

class NetworkManager {
  static final NetworkManager _instance = NetworkManager._internal();
  NetworkManager._internal();
  factory NetworkManager() => _instance;

  final String _baseUrl = 'http://photo.tkyazilim.com/';

  final Dio _dio = Dio();

  Future<LoginModel?> loginUser(
      {required String username, required String password}) async {
    try {
      LoginModel? loginModel;

      Response userData = await _dio.get(_baseUrl, queryParameters: {
        'method': GetApiMethod.login.method,
        'username': username,
        'password': password
      });

      print(userData.realUri);
      if (userData.statusCode == 200) {
        loginModel = LoginModel.fromJson(userData.data);
      }
      return loginModel;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<ParameterModel?> getParams() async {
    try {
      var username = await MySharedPreferences.instance
          .getStringValue(mySharedKey.TKP_USER_NAME);

      var serviceUrl = await MySharedPreferences.instance
          .getStringValue(mySharedKey.TKP_SERVICE_URL);

      _dio.options.queryParameters.addAll(
          {'username': username, 'method': GetApiMethod.parameters.method});
      if (serviceUrl != null && serviceUrl.isNotEmpty) {
        final response = await _dio.get(
          serviceUrl,
          options: Options(headers: {'Accept': 'application/json'}),
        );
        print(response.realUri);
        if (response.statusCode == 200) {
          return ParameterModel.fromJson(response.data);
        } else {
          throw Exception("Bir hata oluştu");
        }
      } else {
        throw Exception("Servis adresi bulunamadı");
      }
    } catch (e) {
      print("Hata: $e");

      rethrow;
    }
  }

  Future<List<ProductListModel>?> getProductList(
      {required Map<String, dynamic> params}) async {
    try {
      var username = await MySharedPreferences.instance
          .getStringValue(mySharedKey.TKP_USER_NAME);

      var serviceUrl = await MySharedPreferences.instance
          .getStringValue(mySharedKey.TKP_SERVICE_URL);

      _dio.options.queryParameters.addAll(
          {'username': username, 'method': GetApiMethod.productQuery.method});
      if (serviceUrl != null && serviceUrl.isNotEmpty) {
        final response = await _dio.get(
          serviceUrl,
          queryParameters: params,
          options: Options(headers: {'Accept': 'application/json'}),
        );
        print(response.realUri);
        if (response.statusCode == 200) {
          return response.data
              .map<ProductListModel>((json) => ProductListModel.fromJson(json))
              .toList();
        } else {
          throw Exception("Bir hata oluştu");
        }
      } else {
        throw Exception("Servis adresi bulunamadı");
      }
    } catch (e) {
      print("Hata: $e");

      rethrow;
    }
  }
}
