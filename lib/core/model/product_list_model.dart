class ProductListModel {
  String? itemCode;
  String? itemDescription;
  String? basePrice;
  String? basePriceCurrencyCode;
  String? tRYPrice;
  bool? isSelected;
  int? currentIndex;
  List<ColorsList>? colors;

  ProductListModel(
      {this.itemCode,
      this.itemDescription,
      this.basePrice,
      this.basePriceCurrencyCode,
      this.tRYPrice,
      this.isSelected = false,
      this.currentIndex = 0,
      this.colors});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemDescription = json['ItemDescription'];
    basePrice = json['BasePrice'];
    basePriceCurrencyCode = json['BasePriceCurrencyCode'];
    tRYPrice = json['TRYPrice'];
    isSelected = false;
    currentIndex = 0;
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
    colorDescription = json['ColorDescription'];
    colorImage = json['ColorImage'];
    stock = json['Stock'];
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
