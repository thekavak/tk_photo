import 'general_list_model.dart';

class ParameterModel {
  List<GeneralListType>? prices;
  List<GeneralListType>? warehouseList;
  List<GeneralListType>? categories;
  List<AttributesModel>? attributes;
  bool? state;
  String? message;

  ParameterModel(
      {this.prices,
      this.warehouseList,
      this.categories,
      this.attributes,
      this.state,
      this.message});

  ParameterModel.fromJson(Map<String, dynamic> json) {
    if (json['prices'] != null) {
      prices = <GeneralListType>[];
      json['prices'].forEach((v) {
        prices!.add(GeneralListType.fromJson(v));
      });
    }
    if (json['warehouseList'] != null) {
      warehouseList = <GeneralListType>[];
      json['warehouseList'].forEach((v) {
        warehouseList!.add(GeneralListType.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <GeneralListType>[];
      json['categories'].forEach((v) {
        categories!.add(GeneralListType.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      attributes = <AttributesModel>[];
      json['attributes'].forEach((v) {
        attributes!.add(AttributesModel.fromJson(v));
      });
    }
    state = json['state'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (prices != null) {
      data['prices'] = prices!.map((v) => v.toJson()).toList();
    }
    if (warehouseList != null) {
      data['warehouseList'] = warehouseList!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    data['state'] = state;
    data['message'] = message;
    return data;
  }
}

class AttributesModel {
  String? attributeTypeCode;
  String? attributeTypeDescription;
  List<GeneralListType>? options;

  AttributesModel(
      {this.attributeTypeCode, this.attributeTypeDescription, this.options});

  AttributesModel.fromJson(Map<String, dynamic> json) {
    attributeTypeCode = json['AttributeTypeCode'];
    attributeTypeDescription = json['AttributeTypeDescription'];
    if (json['Options'] != null) {
      options = <GeneralListType>[];
      json['Options'].forEach((v) {
        options!.add(GeneralListType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AttributeTypeCode'] = attributeTypeCode;
    data['AttributeTypeDescription'] = attributeTypeDescription;
    if (options != null) {
      data['Options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
