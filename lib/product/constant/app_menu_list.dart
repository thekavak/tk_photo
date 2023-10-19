import 'package:flutter/material.dart';

enum AppMenu { productQuery, showAttributes, category, lastAdded }

class AppMenuList {
  List<Map<String, dynamic>> menuList = [
    {
      'icon': Icons.home,
      'title': 'Ürün Ara',
      'id': 1,
      'type': AppMenu.productQuery
    },
    {
      'icon': Icons.person,
      'title': 'Özellikler',
      'id': 2,
      'type': AppMenu.showAttributes
    },
    {
      'icon': Icons.settings,
      'title': 'Kategoriler',
      'id': 3,
      'type': AppMenu.category
    },
    {
      'icon': Icons.settings,
      'title': 'Son Eklenenler',
      'id': 4,
      'type': AppMenu.lastAdded
    },
  ];
}
