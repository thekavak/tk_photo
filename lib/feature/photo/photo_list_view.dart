import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kartal/kartal.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tk_photo/core/model/product_list_model.dart';
import 'package:tk_photo/feature/photo/photo_edit.dart';
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

  String _currentLanguage = 'tr';
  final Map<String, dynamic> _translations = {
    'en': {'stock': 'Stock', 'piece': 'Piece'},
    'tr': {'stock': 'Stok', 'piece': 'Adet'},
    'de': {'stock': 'Lager', 'piece': 'Stück'},
    'ru': {'stock': 'Склад', 'piece': 'Кусок'},
  };

  @override
  void initState() {
    super.initState();
    ref.read(productPhotoProvider.notifier).init();
    isCreating = false;
    photoList = widget.photoList;
    _scrollController = ScrollController();

    for (var i = 0; i < (widget.photoList?.length ?? 0); i++) {
      controllers.add(WidgetsToImageController());
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dil Seçin'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Türkçe'),
                  onTap: () => _changeLanguage('tr'),
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('English'),
                  onTap: () => _changeLanguage('en'),
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Deutsch'),
                  onTap: () => _changeLanguage('de'),
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  child: const Text('Русский'),
                  onTap: () => _changeLanguage('ru'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _changeLanguage(String languageCode) {
    Navigator.of(context).pop(); // Diyalogu kapat
    EasyLoading.show(status: 'Dil Değiştiriliyor...');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _currentLanguage = languageCode;
      });
      EasyLoading.dismiss();
      EasyLoading.showToast('Dil Değiştirildi: $languageCode');
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(productPhotoProvider);
    double width = MediaQuery.of(context).size.width; // Ekranın genişliğini al
    double height =
        width / state.aspectRatio!; // Yüksekliği hesaplaÖrneğin ekranın %60'ı
    return Scaffold(
      appBar: AppBar(
        title: const Text('Önizleme', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              _showLanguageDialog();
            },
            icon: const Icon(Icons.language),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: (state.addVariants == true) ? height + 80 : height,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: (photoList ?? [])
                      .map((e) => buildOneImage(
                            state,
                            e,
                          ))
                      .toList(),
                ),
              ),
            ),
            saveButton(context, state),
            const Divider(),
            settings(state),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  Padding buildOneImage(PhotoPageState state, ProductListModel e) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, bottom: 16, top: 16, right: 16),
      child: WidgetsToImage(
        controller: controllers[photoList!.indexOf(e)],
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(0),
              border:
                  Border.all(color: Colors.grey.withOpacity(0.3), width: 1)),
          child: Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: state.aspectRatio!,
                  child: InkWell(
                    onDoubleTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoEditView(
                                    item: e,
                                  )));
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          onError: (error, stackTrace) =>
                              const Center(child: Text('Resim Yüklenemedi')),
                          image: NetworkImage(
                            e.colors?[e.currentIndex!].colorImage ?? '',
                            scale: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              (e.package != null && e.package!.isNotEmpty)
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          alignment: Alignment.center,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/pngegg.png'))),
                                          height: 40,
                                          width: 40,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(e.package ?? '',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: (e.package ?? '')
                                                                .length >=
                                                            2
                                                        ? 10
                                                        : 14)),
                                          )),
                                    )
                                  : Container()
                            ],
                          ),
                          const Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          child: Text(
                                            "#${e.itemCode}",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: SizedBox(
                                          child: Text(
                                            "${e.basePrice} ${e.basePriceCurrencyCode} / ${_translations[_currentLanguage]?['piece']}",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: SizedBox(
                                          child: Text(
                                            "${e.itemDescription}",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: SizedBox(
                                          child: Text(
                                            "${_translations[_currentLanguage]?['stock']}: ${e.colors?[e.currentIndex!].stock}",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          //buildInformationBant(e.currentIndex!, state),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              state.addVariants == true
                  ? addVariants(photoList!.indexOf(e), state)
                  : Container(),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 1,
                color: Colors.grey.withOpacity(0.3),
              ),
              /* SizedBox(
                height: 30,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          state.showStock == true
                              ? '${photoList![photoList!.indexOf(e)].basePrice} ${photoList![photoList!.indexOf(e)].basePriceCurrencyCode} / ${_translations[_currentLanguage]?['piece']}'
                              : '',
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          state.showStock == true
                              ? 'Stock: ${photoList![photoList!.indexOf(e)].colors?[photoList![photoList!.indexOf(e)].currentIndex!].stock}'
                              : '',
                          style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
              )*/
            ],
          ),
        ),
      ),
    );
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
          /*Row(
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
          ),*/
        ],
      ),
    );
  }

  void saveImages(BuildContext context, PhotoPageState state) async {
    try {
      EasyLoading.show(status: 'Resimler Oluşturuluyor');
      List<XFile> files = [];

      await Future.forEach<WidgetsToImageController>(controllers, (e) async {
        //scroll one by one

        await e.capture().then((value) async {
          if (value == null) {
            return;
          }
          files.add(XFile.fromData(
            Uint8List.fromList(value),
            name: state.itemCodeDesc.toString(),
            mimeType: 'image/png',
          ));
        });
      });

      Share.shareXFiles(files);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Oluşturulurken hata oluştu ${e.toString()}')));
    }
    EasyLoading.dismiss();
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
            });

            WidgetsBinding.instance.addPostFrameCallback((_) async {
              saveImages(context, state);
            });

            setState(() {
              isCreating = false;
            });
          },
        ),
      ),
    );
  }

  SizedBox addVariants(int index, PhotoPageState state) {
    return SizedBox(
      child: Row(
        children: photoList![index]
            .colors!
            .where((element) =>
                element !=
                    photoList![index]
                        .colors![photoList![index].currentIndex!] &&
                element.colorImage.isNotNullOrNoEmpty)
            .map((e) => Padding(
                padding:
                    const EdgeInsets.only(left: 2, right: 2, top: 4, bottom: 4),
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
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.showStock == true
                                ? '#${photoList![index].itemCode}\n${e.colorDescription} - ${e.stock}'
                                : '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                )))
            .toList(),
      ),
    );
    /* return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: photoList![index]
          .colors!
          .where((element) =>
              element !=
                  photoList![index].colors![photoList![index].currentIndex!] &&
              element.colorImage.isNotNullOrNoEmpty)
          .map((e) => Padding(
              padding: const EdgeInsets.all(8.0),
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
              )))
          .toList(),
    );
    */
  }

  SizedBox buildInformationBant(int index, PhotoPageState state) {
    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildShowStock(index, state),
            buildShowPrice(index, state),
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
}
