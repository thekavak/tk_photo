import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/model/product_list_model.dart';

// ignore: must_be_immutable
class PhotoEditView extends ConsumerStatefulWidget {
  ProductListModel? item;
  PhotoEditView({super.key, required this.item});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhotoEditViewState();
}

class _PhotoEditViewState extends ConsumerState<PhotoEditView> {
  ProductListModel? item;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ürün Düzenleme',
              style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                item?.itemCode ?? '',
              ),
              Text(
                item?.itemDescription ?? '',
              ),
              const SizedBox(height: 20),
              ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: item?.colors?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      trailing: IconButton(
                          onPressed: () {
                            if (item?.colors?.length == 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('En az 1 renk olmalıdır')));

                              return;
                            }

                            if (item?.colors?[index].isSelected == true) {
                              item?.colors?.removeAt(index);

                              item?.colors?[0].isSelected = true;
                            } else {
                              item?.colors?.removeAt(index);
                            }
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          )),
                      leading: SizedBox(
                        width: 50,
                        child: Image.network(
                          item?.colors?[index].colorImage ?? '',
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? child
                                  : const CircularProgressIndicator(),
                          errorBuilder: (context, error, stackTrace) {
                            return IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.upload_file_outlined));
                          },
                        ),
                      ),
                      title: Text(item?.colors?[index].colorCode ?? ''),
                      subtitle:
                          Text(item?.colors?[index].colorDescription ?? ''),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider()),
            ],
          ),
        ));
  }
}
