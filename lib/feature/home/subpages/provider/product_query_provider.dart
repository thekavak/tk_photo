import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/model/product_list_model.dart';
import '../../../../product/constant/app_process_enum.dart';
import '../../../../service/network_manager.dart';

import '../product_multi_select.dart';

final productProvider =
    StateNotifierProvider<ProductQueryNotifier, ProductQueryState>((ref) {
  return ProductQueryNotifier();
});

class ProductQueryNotifier extends StateNotifier<ProductQueryState> {
  ProductQueryNotifier()
      : super(const ProductQueryState(
          appState: ApppProcessStatus.initial,
          statusMessage: "Barkod veya ürün kodu giriniz.",
        ));
  final NetworkManager _networkManager = NetworkManager();
  final TextEditingController searchController = TextEditingController();

  void init() {
    searchController.text = "";
    state = state.copyWith(
      appState: ApppProcessStatus.initial,
      statusMessage: "Barkod veya ürün kodu giriniz.",
      product: [],
    );
  }

  getProductList(BuildContext context,
      {required Map<String, dynamic> param}) async {
    if (state.appState == ApppProcessStatus.loading) {
      return;
    }

    String? error;

    FocusScope.of(context).requestFocus(FocusNode());

    //get homeProvider

    state = state.copyWith(
      appState: ApppProcessStatus.loading,
      statusMessage: "Yükleniyor...",
    );

    var response = await _networkManager.getProductList(params: param);

    if (response != null) {
      if (response.isNotEmpty) {
        state = state.copyWith(
          appState: ApppProcessStatus.success,
          statusMessage: "Ürünler listelendi.",
          product: response,
        );

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductMultiSelect(
                  productList: response,
                )));
      } else {
        state = state.copyWith(
          appState: ApppProcessStatus.error,
          statusMessage: "Ürün bulunamadı.",
        );
        error = "Ürün bulunamadı.";
      }
    } else {
      state = state.copyWith(
        appState: ApppProcessStatus.error,
        statusMessage: "Bir hata oluştu. Lütfen tekrar deneyiniz.",
      );
      error = "Bir hata oluştu. Lütfen tekrar deneyiniz.";
    }

    if (error != null) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error),
          duration: const Duration(seconds: 2),
        ),
      );
    }
    print("çıktı");
  }

  Future<void> scanBarcodeNormal(BuildContext context) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
    searchController.text = '';
    searchController.text = barcodeScanRes != "-1" ? barcodeScanRes : "";
    if (searchController.text.isNotEmpty && searchController.text != "-1") {
      // getData(context,{"keyword": searchController.text});
    }
  }
}

class ProductQueryState extends Equatable {
  const ProductQueryState({
    this.appState = ApppProcessStatus.initial,
    this.statusMessage,
    this.product,
  });

  final ApppProcessStatus appState;

  final String? statusMessage;
  final List<ProductListModel>? product;
  @override
  List<Object?> get props => [
        appState,
        statusMessage,
        product,
      ];

  ProductQueryState copyWith({
    ApppProcessStatus? appState,
    String? statusMessage,
    List<ProductListModel>? product,
  }) {
    return ProductQueryState(
      appState: appState ?? this.appState,
      statusMessage: statusMessage ?? this.statusMessage,
      product: product ?? this.product,
    );
  }
}
