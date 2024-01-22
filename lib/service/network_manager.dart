import 'package:flutter/foundation.dart';
import 'package:tk_photo/core/model/parameters_model.dart';
import 'package:tk_photo/service/shared_preferences.dart';

import '../core/model/login_model.dart';
import 'package:dio/dio.dart';

import '../core/model/product_list_model.dart';
import '../core/model/upload_file_model.dart';

enum GetApiMethod {
  login,
  parameters,
  uploadImage,
  productQuery;

  String get value {
    switch (this) {
      case GetApiMethod.login:
        return 'login';
      case GetApiMethod.productQuery:
        return 'getProduct';
      case GetApiMethod.parameters:
        return 'getParams';
      case GetApiMethod.uploadImage:
        return 'uploadImage';
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

  Future<FileResponse?> uploadProductImage({required FormData formData}) async {
    try {
      var serviceUrl = await MySharedPreferences.instance
          .getStringValue(mySharedKey.TKP_SERVICE_URL);
      if (serviceUrl != null && serviceUrl.isNotEmpty) {
        Response uploadResponse = await _dio.post(serviceUrl,
            queryParameters: {
              'method': GetApiMethod.uploadImage.method,
            },
            data: formData);

        if (uploadResponse.statusCode == 200) {
          return FileResponse.fromJson(uploadResponse.data);
        } else {
          return null;
        }
      } else {
        throw Exception("Servis adresi bulunamadı");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<LoginModel?> loginUser(
      {required String username, required String password}) async {
    try {
      LoginModel? loginModel;

      Response userData = await _dio.get(_baseUrl, queryParameters: {
        'method': GetApiMethod.login.method,
        'username': username,
        'password': password
      });
      if (userData.statusCode == 200) {
        loginModel = LoginModel.fromJson(userData.data);
      }
      return loginModel;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }

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

      var priceList = await MySharedPreferences.instance
              .getGlobalFilterModel(mySharedKey.TKP_GLOBAL_FILTER_PRICE_LIST) ??
          [];

      var warehouseList = await MySharedPreferences.instance
              .getGlobalFilterModel(mySharedKey.TKP_GLOBAL_FILTER_WAREHOUSE) ??
          [];

      var price = priceList
              .where((element) => element.isSelected == true)
              .isNotEmpty
          ? priceList.where((element) => element.isSelected == true).first.code
          : priceList.first.code;

      var warehouse = warehouseList
              .where((element) => element.isSelected == true)
              .isNotEmpty
          ? warehouseList
              .where((element) => element.isSelected == true)
              .first
              .code
          : warehouseList.first.code;

      _dio.options.queryParameters.addAll(
          {'username': username, 'method': GetApiMethod.productQuery.method});

      _dio.options.queryParameters
          .addAll({'priceCode': price, 'warehouseCode': warehouse});

      if (serviceUrl != null && serviceUrl.isNotEmpty) {
        final response = await _dio.get(
          serviceUrl,
          queryParameters: params,
          options: Options(headers: {'Accept': 'application/json'}),
        );
        if (kDebugMode) {
          print(response.realUri);
        }

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
      if (kDebugMode) {
        print(e);
      }

      rethrow;
    }
  }
}
