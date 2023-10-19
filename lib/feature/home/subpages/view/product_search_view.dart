import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';

import '../provider/product_query_provider.dart';

class ProductQueryView extends ConsumerStatefulWidget {
  const ProductQueryView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductQueryViewState();
}

class _ProductQueryViewState extends ConsumerState<ProductQueryView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(productProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProviderData = ref.watch(productProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Sorgulama',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: Padding(
        padding: context.paddingNormal,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              productQueryColumn(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Column productQueryColumn(BuildContext context, WidgetRef ref) {
    var providerKeyword = ref.watch(productProvider.notifier);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: providerKeyword.searchController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(16), labelText: "Barkod"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: providerKeyword.searchController.text.isEmpty
                  ? IconButton(
                      onPressed: () {
                        providerKeyword.scanBarcodeNormal(context);
                      },
                      icon: const Icon(Icons.qr_code_scanner))
                  : IconButton(
                      onPressed: () {
                        providerKeyword.init();
                      },
                      icon: const Icon(Icons.cancel)),
            )
          ],
        ),
        SizedBox(
          height: context.dynamicHeight(0.015),
        ),
        ElevatedButton(
            onPressed: () {
              if (providerKeyword.searchController.text.isEmpty) {
                // haata mesajı
                const error =
                    SnackBar(content: Text("Barkod alanı boş olamaz."));
                ScaffoldMessenger.of(context).showSnackBar(error);

                return;
              }
              // ürün sorgulamadan buradan data gönderiyoruz
              providerKeyword.getProductList(context,
                  param: {"keyword": providerKeyword.searchController.text});
            },
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48)),
            child: const Text("Ürün Sorgula",
                style: TextStyle(color: Colors.white)))
      ],
    );
  }
}
