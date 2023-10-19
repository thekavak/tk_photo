class ProductDetailModel {
  String? itemCode;
  String? itemDescription;
  double? basePrice;
  String? basePriceCurrencyCode;
  double? tryPrice;
  String? companyLogo;
  int? stock;
  List<ProductDetail>? colors;

  ProductDetailModel(
      {this.itemCode,
      this.itemDescription,
      this.basePrice,
      this.basePriceCurrencyCode,
      this.tryPrice,
      this.companyLogo,
      this.stock,
      this.colors});

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    itemCode = json['ItemCode'];
    itemDescription = json['ItemDescription'];
    basePrice = json['BasePrice'];
    basePriceCurrencyCode = json['BasePriceCurrencyCode'];
    tryPrice = json['TRYPrice'];
    companyLogo = json['CompanyLogo'];
    stock = json['Stock'];
    if (json['Colors'] != null) {
      colors = <ProductDetail>[];
      json['Colors'].forEach((v) {
        colors!.add(ProductDetail.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ItemCode'] = itemCode;
    data['ItemDescription'] = itemDescription;
    data['BasePrice'] = basePrice;
    data['BasePriceCurrencyCode'] = basePriceCurrencyCode;
    data['TRYPrice'] = tryPrice;
    data['CompanyLogo'] = companyLogo;
    data['Stock'] = stock;
    if (colors != null) {
      data['Colors'] = colors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductDetail {
  String? colorCode;
  String? colorDescription;
  String? colorImage;
  int? stock;
  bool? isSelected = false;

  ProductDetail(
      {this.colorCode,
      this.colorDescription,
      this.colorImage,
      this.stock,
      this.isSelected});

  ProductDetail.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
