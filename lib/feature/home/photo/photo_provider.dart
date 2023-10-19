// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/model_old/product_detail_model.dart';
import '../../../product/constant/app_process_enum.dart';

enum AppPropertiesEnum {
  addVariants,
  showLogo,
  showPrice,
  showBasePrice,
  showStock,
  showOnlyOneStock,
}

final productPhotoProvider =
    StateNotifierProvider<ProductPhotoProvider, PhotoPageState>((ref) {
  return ProductPhotoProvider();
});

class ProductPhotoProvider extends StateNotifier<PhotoPageState> {
  ProductPhotoProvider() : super(const PhotoPageState());

  changeIndex(
    int index,
  ) {
    state = state.copyWith(currentIndex: index);
    print("index$index");
  }

  changeStatus(AppPropertiesEnum property, bool value) {
    switch (property) {
      case AppPropertiesEnum.addVariants:
        state = state.copyWith(addVariants: value);
        break;
      case AppPropertiesEnum.showLogo:
        state = state.copyWith(showLogo: value);
        break;
      case AppPropertiesEnum.showPrice:
        state = state.copyWith(showPrice: value);
        if (value == false) {
          changeStatus(AppPropertiesEnum.showBasePrice, value);
        }
        break;
      case AppPropertiesEnum.showBasePrice:
        state = state.copyWith(showBasePrice: value);
        break;
      case AppPropertiesEnum.showStock:
        state = state.copyWith(showStock: value);
        if (value == false) {
          changeStatus(AppPropertiesEnum.showOnlyOneStock, value);
        }
        break;
      case AppPropertiesEnum.showOnlyOneStock:
        state = state.copyWith(showOnlyOneStock: value);
        break;
      default:
    }
  }
}

class PhotoPageState extends Equatable {
  const PhotoPageState({
    this.appState = ApppProcessStatus.loading,
    this.photoList = const [],
    this.currentIndex = 0,
    this.itemCode,
    this.itemCodeDesc,
    this.basePrice,
    this.basePriceCurrency,
    this.tryPrice,
    this.tryPriceCurrency,
    this.companyLogo,
    this.stock,
    this.colors,
    this.addVariants = false,
    this.showLogo = false,
    this.showPrice = true,
    this.showBasePrice = true,
    this.showStock = true,
    this.showOnlyOneStock = false,
  });

  final ApppProcessStatus appState;
  final List<String>? photoList;
  final int? currentIndex;
  final String? itemCode;
  final String? itemCodeDesc;
  final String? basePrice;
  final String? basePriceCurrency;
  final String? tryPrice;
  final String? tryPriceCurrency;
  final String? companyLogo;
  final int? stock;
  final List<ProductDetail>? colors;
  final bool? addVariants;
  final bool? showLogo;
  final bool? showPrice;
  final bool? showBasePrice;
  final bool? showStock;
  final bool? showOnlyOneStock;

  @override
  List<Object?> get props => [
        appState,
        photoList,
        currentIndex,
        itemCode,
        itemCodeDesc,
        basePrice,
        basePriceCurrency,
        tryPrice,
        tryPriceCurrency,
        companyLogo,
        stock,
        colors,
        addVariants,
        showLogo,
        showPrice,
        showBasePrice,
        showStock,
        showOnlyOneStock,
      ];

  PhotoPageState copyWith({
    ApppProcessStatus? appState,
    List<String>? photoList,
    int? currentIndex,
    String? itemCode,
    String? itemCodeDesc,
    String? basePrice,
    String? basePriceCurrency,
    String? tryPrice,
    String? tryPriceCurrency,
    String? companyLogo,
    int? stock,
    List<ProductDetail>? colors,
    bool? addVariants,
    bool? showLogo,
    bool? showPrice,
    bool? showBasePrice,
    bool? showStock,
    bool? showOnlyOneStock,
  }) {
    return PhotoPageState(
      appState: appState ?? this.appState,
      photoList: photoList ?? this.photoList,
      currentIndex: currentIndex ?? this.currentIndex,
      itemCode: itemCode ?? this.itemCode,
      itemCodeDesc: itemCodeDesc ?? this.itemCodeDesc,
      basePrice: basePrice ?? this.basePrice,
      basePriceCurrency: basePriceCurrency ?? this.basePriceCurrency,
      tryPrice: tryPrice ?? this.tryPrice,
      tryPriceCurrency: tryPriceCurrency ?? this.tryPriceCurrency,
      companyLogo: companyLogo ?? this.companyLogo,
      stock: stock ?? this.stock,
      colors: colors ?? this.colors,
      addVariants: addVariants ?? this.addVariants,
      showLogo: showLogo ?? this.showLogo,
      showPrice: showPrice ?? this.showPrice,
      showBasePrice: showBasePrice ?? this.showBasePrice,
      showStock: showStock ?? this.showStock,
      showOnlyOneStock: showOnlyOneStock ?? this.showOnlyOneStock,
    );
  }
}
