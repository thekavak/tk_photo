import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tk_photo/core/model/product_list_model.dart';
import 'package:tk_photo/feature/photo/photo_provider.dart';
import 'package:tk_photo/product/widgets/button/app_elevated_button.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../product/constant/app_color.dart';

// ignore: must_be_immutable
class PhotoListView extends ConsumerStatefulWidget {
  List<ProductListModel>? photoList;
  PhotoListView({super.key, required this.photoList});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PhotoListViewState();
}

class _PhotoListViewState extends ConsumerState<PhotoListView> {
  ScrollController? _scrollController;
  List<ProductListModel>? photoList;
  List<WidgetsToImageController> controllers = [];

  bool? isCreating = false;

  @override
  void initState() {
    super.initState();
    isCreating = false;
    photoList = widget.photoList;
    _scrollController = ScrollController();

    for (var i = 0; i < (widget.photoList?.length ?? 0); i++) {
      controllers.add(WidgetsToImageController());
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController?.animateTo(
          _scrollController?.position.maxScrollExtent ?? 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(productPhotoProvider);
    return Scaffold(
        appBar: AppBar(
          title:
              const Text('Photo List', style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildLoading(state),
              saveButton(context, state),
              const Divider(),
              settings(state),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ));
  }

  Padding settings(PhotoPageState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Varyasyonları Ekle',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Switch(
                value: state.addVariants ?? false,
                onChanged: (value) {
                  ref
                      .read(productPhotoProvider.notifier)
                      .changeStatus(AppPropertiesEnum.addVariants, value);
                },
                activeTrackColor: ColorConstants.mtPrimary,
                activeColor: Colors.white,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Logo',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Switch(
                value: state.showLogo ?? false,
                onChanged: (value) {
                  ref
                      .read(productPhotoProvider.notifier)
                      .changeStatus(AppPropertiesEnum.showLogo, value);
                },
                activeTrackColor: ColorConstants.mtPrimary,
                activeColor: Colors.white,
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Fiyat Göster',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Switch(
                value: state.showPrice ?? false,
                onChanged: (value) {
                  ref
                      .read(productPhotoProvider.notifier)
                      .changeStatus(AppPropertiesEnum.showPrice, value);
                },
                activeTrackColor: ColorConstants.mtPrimary,
                activeColor: Colors.white,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('İkinci Fiyat Göster',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Switch(
                value: state.showBasePrice ?? false,
                onChanged: (value) {
                  ref
                      .read(productPhotoProvider.notifier)
                      .changeStatus(AppPropertiesEnum.showBasePrice, value);
                },
                activeTrackColor: ColorConstants.mtPrimary,
                activeColor: Colors.white,
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Stok Göster',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Switch(
                value: state.showStock ?? false,
                onChanged: (value) {
                  ref
                      .read(productPhotoProvider.notifier)
                      .changeStatus(AppPropertiesEnum.showStock, value);
                },
                activeTrackColor: ColorConstants.mtPrimary,
                activeColor: Colors.white,
              ),
            ],
          ),
          /* Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Seçilen Ürün Stok Göster',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Switch(
                value: state.showOnlyOneStock ?? false,
                onChanged: (value) {
                  ref
                      .read(productPhotoProvider.notifier)
                      .changeStatus(AppPropertiesEnum.showOnlyOneStock, value);
                },
                activeTrackColor: ColorConstants.mtPrimary,
                activeColor: Colors.white,
              ),
            ],
          ), */
        ],
      ),
    );
  }

  Padding saveButton(BuildContext context, PhotoPageState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: AppElevatedButton(
          title: 'Resim Oluştur',
          callback: () async {
            setState(() {
              isCreating = true;
              //scrool to start
              _scrollController?.animateTo(
                  _scrollController?.position.minScrollExtent ?? 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease);
            });
            try {
              List<Uint8List> images = [];
              List<XFile> files = [];

              await Future.forEach<WidgetsToImageController>(controllers,
                  (e) async {
                print(e.toString());

                await e.capture().then((value) async {
                  files.add(XFile.fromData(
                    Uint8List.fromList(value!),
                    name: state.itemCodeDesc.toString(),
                    mimeType: 'image/png',
                  ));
                });
              });

              Share.shareXFiles(files);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Oluşturulurken hata oluştu ${e.toString()}')));
            }
            setState(() {
              isCreating = false;
            });
          },
        ),
      ),
    );
  }

  Widget buildProduct(PhotoPageState state) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: WidgetsToImage(
              controller: controllers[index],
              child: AspectRatio(
                aspectRatio: 4 / 5,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fitWidth,
                        image: NetworkImage(photoList![index]
                                .colors?[photoList![index].currentIndex!]
                                .colorImage ??
                            '')),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      state.addVariants == true
                          ? addVariants(index, state)
                          : Container(),
                      buildInformationBant(index, state),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: widget.photoList?.length ?? 0,
      ),
    );
  }

  Column addVariants(int index, PhotoPageState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: photoList![index]
          .colors!
          .where((element) =>
              element !=
              photoList![index].colors![photoList![index].currentIndex!])
          .map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: badges.Badge(
                badgeStyle: badges.BadgeStyle(
                    badgeColor:
                        isCreating == false ? Colors.grey : Colors.transparent),
                badgeContent: InkWell(
                  onTap: () {
                    setState(() {
                      photoList![index]
                          .colors!
                          .removeAt(photoList![index].colors!.indexOf(e));
                    });
                  },
                  child: Text(
                    isCreating == false ? 'X' : '',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      photoList![index].currentIndex =
                          photoList![index].colors!.indexOf(e);
                    });
                  },
                  child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(e.colorImage ?? '')),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        state.showStock == true ? '${e.stock}' : '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.mtPrimary),
                      )),
                ),
              )))
          .toList(),
    );
  }

  Container buildInformationBant(int index, PhotoPageState state) {
    return Container(
      height: 60,
      color: Colors.grey.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("#${widget.photoList![index].itemCode}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                Text(
                  photoList![index].itemDescription ?? '',
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                buildShowStock(index, state),
                buildShowPrice(index, state),
              ],
            )
          ],
        ),
      ),
    );
  }

  Text buildShowPrice(int index, PhotoPageState state) {
    if (state.showPrice == true && state.showBasePrice == false) {
      return Text(
        '${widget.photoList![index].basePrice} ${widget.photoList![index].basePriceCurrencyCode}',
      );
    } else if (state.showPrice == true && state.showBasePrice == true) {
      return Text(
        '${widget.photoList![index].tRYPrice} TRY',
      );
    }
    return const Text("");
  }

  Text buildShowStock(int index, PhotoPageState state) {
    if (state.showStock == true) {
      return Text(
          "Stok ${widget.photoList![index].colors?[photoList![index].currentIndex!].stock}",
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold));
    } else {
      return const Text("");
    }
  }

  Widget buildLoading(PhotoPageState state) {
    /*if (state.appState == ApppProcessStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } */
    return buildProduct(state);
  }
}
