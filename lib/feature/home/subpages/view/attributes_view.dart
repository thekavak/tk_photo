import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tk_photo/product/widgets/button/app_elevated_button.dart';

import '../../home_provider.dart';
import '../provider/product_query_provider.dart';

class AttributesView extends ConsumerStatefulWidget {
  const AttributesView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AttributesViewState();
}

class _AttributesViewState extends ConsumerState<AttributesView> {
  @override
  Widget build(BuildContext context) {
    final attributesList = ref.read(homeProvider.notifier).attributesList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Özellikler',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
            child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    top: 36.0, left: 16, right: 16, bottom: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: attributesList!
                      .map((e) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.attributeTypeDescription.toString()),
                                const SizedBox(height: 10),
                                DropdownButtonFormField(
                                  onChanged: (value) {
                                    setState(() {
                                      e.options?.forEach((element) {
                                        if (element.code == value) {
                                          element.isSelected = true;
                                          print(element.name);
                                        } else {
                                          element.isSelected = false;
                                        }
                                      });
                                    });
                                  },
                                  items: e.options
                                          ?.map((ee) => DropdownMenuItem(
                                                value: ee.code,
                                                child: Text(ee.name
                                                    .toString()
                                                    .toUpperCase()),
                                              ))
                                          .toList() ??
                                      [],
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppElevatedButton(
                  title: 'Ürün Getir',
                  callback: () async {
                    var param = <String, dynamic>{};
                    for (var item in attributesList) {
                      if (item.options != null) {
                        // true / false onu belirle
                        var selected = item.options!
                            .where((element) => element.isSelected == true)
                            .toList();
                        if (selected.isNotEmpty) {
                          param[item.attributeTypeCode.toString()] =
                              selected.first.code;
                        }
                      }
                    }

                    ref
                        .watch(productProvider.notifier)
                        .getProductList(context, param: param);
                  }),
            )
          ],
        )),
      ),
    );
  }
}
