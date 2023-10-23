import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tk_photo/core/model/product_list_model.dart';

import '../../photo/photo_list_view.dart';

// ignore: must_be_immutable
class ProductMultiSelect extends ConsumerStatefulWidget {
  List<ProductListModel>? productList;
  ProductMultiSelect({super.key, required this.productList});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductMultiSelectState();
}

class _ProductMultiSelectState extends ConsumerState<ProductMultiSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Ürün Listesi',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: [
          IconButton(
              onPressed: () {
                List<ProductListModel>? productListChecked = [];

                for (var item in widget.productList!) {
                  if (item.isSelected == true) {
                    print(item);
                    productListChecked.add(item);
                  }
                }

                if (productListChecked.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lütfen Ürün Seçiniz')));
                  return;
                }

                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (context) => PhotoListView(
                          photoList: productListChecked,
                        )));
              },
              icon: const Icon(Icons.check_box_rounded))
        ],
      ),
      body: SafeArea(
        child: ListView.separated(
            itemCount: widget.productList?.length ?? 0,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title:
                    Text(widget.productList![index].itemDescription.toString()),
                subtitle: Text(widget.productList![index].itemCode.toString()),
                checkColor: Colors.white,
                value: widget.productList![index].isSelected,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    widget.productList![index].isSelected = value!;
                  });
                },
              );
            }),
      ),
    );
  }
}
