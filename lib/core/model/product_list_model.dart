class ProductListModel {
  String? itemCode;
  String? itemDescription;
  String? basePrice;
  String? basePriceCurrencyCode;
  String? tRYPrice;
  bool? isSelected;
  int? currentIndex;
  String? additionalInfo;
  String? package;

  List<ColorsList>? colors;

  ProductListModel(
      {this.itemCode,
      this.itemDescription,
      this.basePrice,
      this.basePriceCurrencyCode,
      this.tRYPrice,
      this.isSelected = false,
      this.currentIndex = 0,
      this.package,
      this.additionalInfo,
      this.colors});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'] != null && json['ItemCode'].length > 20
        ? json['ItemCode'].substring(0, 20)
        : json['ItemCode'];
    itemDescription =
        json['ItemDescription'] != null && json['ItemDescription'].length > 34
            ? json['ItemDescription'].substring(0, 34)
            : json['ItemDescription'];
    basePrice = json['BasePrice'];
    basePriceCurrencyCode = json['BasePriceCurrencyCode'];
    tRYPrice = json['TRYPrice'];
    isSelected = false;
    additionalInfo = json['AdditionalInfo'] ?? '';
    currentIndex = 0;
    package = json['Package'];
    if (json['Colors'] != null) {
      colors = <ColorsList>[];
      json['Colors'].forEach((v) {
        colors!.add(ColorsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemCode'] = itemCode;
    data['ItemDescription'] = itemDescription;
    data['BasePrice'] = basePrice;
    data['BasePriceCurrencyCode'] = basePriceCurrencyCode;
    data['TRYPrice'] = tRYPrice;
    data['isSelected'] = isSelected;
    data['currentIndex'] = currentIndex;
    data['Package'] = package;
    data['AdditionalInfo'] = additionalInfo;
    if (colors != null) {
      data['Colors'] = colors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ColorsList {
  String? colorCode;
  String? colorDescription;
  String? colorImage;
  int? stock;
  bool? isSelected;

  ColorsList({
    this.colorCode,
    this.colorDescription,
    this.colorImage,
    this.stock,
    this.isSelected = false,
  });

  ColorsList.fromJson(Map<String, dynamic> json) {
    colorCode = json['ColorCode'];
    colorDescription =
        json['ColorDescription'] != null && json['ColorDescription'].length > 9
            ? json['ColorDescription'].substring(0, 9)
            : json['ColorDescription'];
    colorImage = json['ColorImage'];
    stock = json['Stock'] != null && json['Stock'] > 500 ? -1 : json['Stock'];
    isSelected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ColorCode'] = colorCode;
    data['ColorDescription'] = colorDescription;
    data['ColorImage'] = colorImage;
    data['Stock'] = stock;
    data['isSelected'] = isSelected;
    return data;
  }
}
