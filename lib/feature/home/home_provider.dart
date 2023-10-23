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

  String? _selectedPrice;
  String? _selectedWarehouse;

  String? get selectedPrice => _selectedPrice;
  String? get selectedWarehouse => _selectedWarehouse;

  init() async {
    await getGlobalFilterData();
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

    _selectedPrice = _priceList.first.code;
    _selectedWarehouse = _warehouseList.first.code;

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
