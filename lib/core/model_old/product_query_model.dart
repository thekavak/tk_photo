// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

class ProductQueryModel {
  bool? resultType;
  String? imageURL;
  List<Product>? product;
  List<Inventory>? inventory;
  List<SearchList>? searchList;

  ProductQueryModel(
      {this.resultType,
      this.imageURL,
      this.product,
      this.inventory,
      this.searchList});

  ProductQueryModel.fromJson(Map<String, dynamic> json) {
    resultType = json['ResultType'];
    imageURL = json['ImageURL'];
    if (json['Product'] != null) {
      product = <Product>[];
      json['Product'].forEach((v) {
        product!.add(Product.fromJson(v));
      });
    }
    if (json['Inventory'] != null) {
      inventory = <Inventory>[];
      json['Inventory'].forEach((v) {
        inventory!.add(Inventory.fromJson(v));
      });
    }
    if (json['SearchList'] != null) {
      searchList = <SearchList>[];
      json['SearchList'].forEach((v) {
        searchList!.add(SearchList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ResultType'] = resultType;
    data['ImageURL'] = imageURL;
    if (product != null) {
      data['Product'] = product!.map((v) => v.toJson()).toList();
    }
    if (inventory != null) {
      data['Inventory'] = inventory!.map((v) => v.toJson()).toList();
    }
    if (searchList != null) {
      data['SearchList'] = searchList!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  bool operator ==(covariant ProductQueryModel other) {
    if (identical(this, other)) return true;

    return other.resultType == resultType &&
        other.imageURL == imageURL &&
        listEquals(other.product, product) &&
        listEquals(other.inventory, inventory) &&
        listEquals(other.searchList, searchList);
  }

  @override
  int get hashCode {
    return resultType.hashCode ^
        imageURL.hashCode ^
        product.hashCode ^
        inventory.hashCode ^
        searchList.hashCode;
  }
}

class Product {
  String? optionName;
  String? optionValue;

  Product({this.optionName, this.optionValue});

  Product.fromJson(Map<String, dynamic> json) {
    optionName = json['OptionName'];
    optionValue = json['OptionValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OptionName'] = optionName;
    data['OptionValue'] = optionValue;
    return data;
  }
}

class Inventory {
  String? warehouseCode;
  String? warehouseDescription;
  List<Values>? values;

  Inventory({this.warehouseCode, this.warehouseDescription, this.values});

  Inventory.fromJson(Map<String, dynamic> json) {
    warehouseCode = json['WarehouseCode'];
    warehouseDescription = json['WarehouseDescription'];
    if (json['Values'] != null) {
      values = <Values>[];
      json['Values'].forEach((v) {
        values!.add(Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['WarehouseCode'] = warehouseCode;
    data['WarehouseDescription'] = warehouseDescription;
    if (values != null) {
      data['Values'] = values!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  String? optionName;
  int? optionValue;

  Values({this.optionName, this.optionValue});

  Values.fromJson(Map<String, dynamic> json) {
    optionName = json['OptionName'];
    optionValue = json['OptionValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['OptionName'] = optionName;
    data['OptionValue'] = optionValue;
    return data;
  }
}

class SearchList {
  String? itemCode;
  String? itemDescription;
  String? addInfo;

  SearchList({this.itemCode, this.itemDescription, this.addInfo});

  SearchList.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemDescription = json['ItemDescription'];
    addInfo = json['AddInfo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['ItemCode'] = itemCode;
    data['ItemDescription'] = itemDescription;
    data['AddInfo'] = addInfo;
    return data;
  }
}
