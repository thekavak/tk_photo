import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/model/general_list_model.dart';
import '../../core/model/parameters_model.dart';
import '../../product/constant/app_menu_list.dart';
import '../../service/shared_preferences.dart';
import 'subpages/view/attributes_view.dart';
import 'subpages/view/categoriy_list_view.dart';
import 'subpages/view/product_search_view.dart';

final homeProvider = ChangeNotifierProvider<HomePageProvider>((ref) {
  return HomePageProvider();
});

class HomePageProvider extends ChangeNotifier {
  List<GeneralListType> _priceList = [
    GeneralListType(code: '0', name: 'Seçiniz')
  ];
  List<GeneralListType> _warehouseList = [
    GeneralListType(code: '0', name: 'Seçiniz')
  ];

  List<GeneralListType> _categoryList = [];
  List<AttributesModel> _attributesList = [];

  List<GeneralListType>? get categoryList => _categoryList;
  List<GeneralListType>? get priceList => _priceList;
  List<GeneralListType>? get warehouseList => _warehouseList;
  List<AttributesModel>? get attributesList => _attributesList;

  TextEditingController stockLimitController = TextEditingController(text: '0');

  String? _selectedPrice;
  String? _selectedWarehouse;

  String? get selectedPrice => _selectedPrice;
  String? get selectedWarehouse => _selectedWarehouse;

  init() async {
    await getGlobalFilterData();
  }

  setStockLimit(String value) async {
    stockLimitController.text = value;
    await MySharedPreferences.instance.setStringValue(
      mySharedKey.TKP_GLOBAL_FILTER_STOCK_LIMIT,
      value,
    );

    await getGlobalFilterData();
    notifyListeners();
  }

  setPriceList(String? code) async {
    for (var element in _priceList) {
      if (element.code == code) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    }
    await MySharedPreferences.instance.setGlobalFilterModel(
      _priceList,
      mySharedKey.TKP_GLOBAL_FILTER_PRICE_LIST,
    );

    await getGlobalFilterData();
    notifyListeners();
  }

  setWarehouseList(String? code) async {
    for (var element in _warehouseList) {
      if (element.code == code) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    }

    await MySharedPreferences.instance.setGlobalFilterModel(
      _warehouseList,
      mySharedKey.TKP_GLOBAL_FILTER_WAREHOUSE,
    );

    await getGlobalFilterData();

    notifyListeners();
  }

  Future<void> getGlobalFilterData() async {
    _priceList = await MySharedPreferences.instance
            .getGlobalFilterModel(mySharedKey.TKP_GLOBAL_FILTER_PRICE_LIST) ??
        [];

    _warehouseList = await MySharedPreferences.instance
            .getGlobalFilterModel(mySharedKey.TKP_GLOBAL_FILTER_WAREHOUSE) ??
        [];

    _categoryList = await MySharedPreferences.instance
            .getGlobalFilterModel(mySharedKey.TKP_GLOBAL_FILTER_CATEGORY) ??
        [];

    _attributesList = await MySharedPreferences.instance
            .getAttributes(mySharedKey.TKP_GLOBAL_FILTER_ATTRIBUTES) ??
        [];

    _selectedPrice =
        _priceList.where((element) => element.isSelected == true).isNotEmpty
            ? _priceList.where((element) => element.isSelected!).first.code
            : _priceList.first.code;

    _selectedWarehouse =
        _warehouseList.where((element) => element.isSelected == true).isNotEmpty
            ? _warehouseList.where((element) => element.isSelected!).first.code
            : _warehouseList.first.code;

    stockLimitController.text = await MySharedPreferences.instance
            .getStringValue(mySharedKey.TKP_GLOBAL_FILTER_STOCK_LIMIT) ??
        '0';

    stockLimitController.text =
        stockLimitController.text == '' ? '0' : stockLimitController.text;

    notifyListeners();
  }

  gotoMenuPage(BuildContext context, AppMenu type) {
    switch (type) {
      case AppMenu.productQuery:
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const ProductQueryView()));
        break;
      case AppMenu.showAttributes:
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const AttributesView()));
        break;
      case AppMenu.category:
        Navigator.of(context).push(MaterialPageRoute(
            fullscreenDialog: true,
            builder: (context) => const CategoryListView()));
        break;
      default:
    }
  }
}
