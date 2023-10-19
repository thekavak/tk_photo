import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../home_provider.dart';
import '../provider/product_query_provider.dart';

class CategoryListView extends ConsumerStatefulWidget {
  const CategoryListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CategoryListViewState();
}

class _CategoryListViewState extends ConsumerState<CategoryListView> {
  @override
  Widget build(BuildContext context) {
    var categoryList = ref.read(homeProvider.notifier).categoryList;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategoriler',
            style: TextStyle(color: Colors.white, fontSize: 20)),
      ),
      body: SafeArea(
        top: true,
        child: ListView.separated(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(categoryList![index].name.toString()),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  ref
                      .watch(productProvider.notifier)
                      .getProductList(context, param: {
                    "ProductHierarchyID": categoryList[index].code,
                  });
                },
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: categoryList?.length ?? 0),
      ),
    );
  }
}
