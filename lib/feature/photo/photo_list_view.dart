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
    print(state.aspectRatio!);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo List', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height,
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
        child: AspectRatio(
          aspectRatio: state.aspectRatio!,
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state.addVariants == true
                        ? addVariants(e.currentIndex!, state)
                        : Container(),
                    state.showLogo == true
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 80,
                              child: Image.network(
                                state.companyLogo ?? '',
                                loadingBuilder: (context, child,
                                        loadingProgress) =>
                                    loadingProgress == null
                                        ? child
                                        : const CircularProgressIndicator(),
                                errorBuilder: (context, error, stackTrace) {
                                  return IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.upload_file_outlined));
                                },
                              ),
                            ))
                        : Container()
                  ],
                ),
                const Spacer(),
                buildInformationBant(e.currentIndex!, state),
              ],
            ),
          ),
        ),
      ),
    );
  }

/*
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(productPhotoProvider);

    return Scaffold(
        appBar: AppBar(
          title:
              const Text('Photo List', style: TextStyle(color: Colors.white)),
          actions: [
            // change language
            IconButton(
              icon: const Icon(Icons.language),
              onPressed: _showLanguageDialog,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //buildLoading(state),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: AspectRatio(
                          aspectRatio: state.aspectRatio!,
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.6,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    photoList![state.currentIndex!]
                                            .colors?[
                                                photoList![state.currentIndex!]
                                                    .currentIndex!]
                                            .colorImage ??
                                        '',
                                  ),
                                  onError: (error, stackTrace) =>
                                      const AssetImage(
                                          'assets/could_not_load_img.jpg'),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        state.addVariants == true
                                            ? addVariants(
                                                state.currentIndex!, state)
                                            : Container(),
                                        state.showLogo == true
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: SizedBox(
                                                  width: 80,
                                                  child: Image.network(
                                                    state.companyLogo ?? '',
                                                    loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) =>
                                                        loadingProgress == null
                                                            ? child
                                                            : const CircularProgressIndicator(),
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return IconButton(
                                                          onPressed: () {},
                                                          icon: const Icon(Icons
                                                              .upload_file_outlined));
                                                    },
                                                  ),
                                                ))
                                            : Container()
                                      ],
                                    ),
                                    const Spacer(),
                                    buildInformationBant(
                                        state.currentIndex!, state),
                                  ],
                                ),
                              ))),
                    )
                  ],
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
        ));
  } */
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
        ],
      ),
    );
  }

  void saveImages(BuildContext context, PhotoPageState state) async {
    try {
      EasyLoading.show(status: 'Resimler Oluşturuluyor');
      List<Uint8List> images = [];
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

  Widget buildProduct(PhotoPageState state) {
<<<<<<< Updated upstream
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.photoList?.length ?? 0,
          (index) => Padding(
            padding: const EdgeInsets.all(16.0),
            child: AspectRatio(
                aspectRatio: state.aspectRatio!,
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          photoList![state.currentIndex!]
                                  .colors?[photoList![state.currentIndex!]
                                      .currentIndex!]
                                  .colorImage ??
                              '',
                        ),
                        onError: (error, stackTrace) =>
                            const AssetImage('assets/could_not_load_img.jpg'),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              state.addVariants == true
                                  ? addVariants(state.currentIndex!, state)
                                  : Container(),
                              state.showLogo == true
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                        width: 80,
                                        child: Image.network(
                                          state.companyLogo ?? '',
                                          loadingBuilder: (context, child,
                                                  loadingProgress) =>
                                              loadingProgress == null
                                                  ? child
                                                  : const CircularProgressIndicator(),
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons
                                                    .upload_file_outlined));
                                          },
                                        ),
                                      ))
                                  : Container()
                            ],
=======
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            widget.photoList?.length ?? 0,
            (index) => Padding(
              padding: const EdgeInsets.only(
                left: 8,
              ),
              child: Center(
                child: WidgetsToImage(
                  controller: controllers[index],
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey, width: 1)),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          height: MediaQuery.of(context).size.width +
                              (MediaQuery.of(context).size.width * 0.2),
                          width: MediaQuery.of(context).size.width,
                          child: InkWell(
                            onDoubleTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PhotoEditView(
                                            item: photoList![index],
                                          )));
                              setState(() {});
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  image: NetworkImage(
                                    photoList![index]
                                            .colors?[
                                                photoList![index].currentIndex!]
                                            .colorImage ??
                                        '',
                                  ),
                                  onError: (error, stackTrace) =>
                                      const AssetImage(
                                          'assets/could_not_load_img.jpg'),
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        photoList![index].packageQuantity !=
                                                null
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8.0, top: 8),
                                                child: Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration:
                                                      const BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                            'assets/images/package.png')),
                                                  ),
                                                  child: Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: Text(
                                                        photoList![index]
                                                            .packageQuantity
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container()
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              "#${widget.photoList![index].itemCode}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color:
                                                      ColorConstants.mtPrimary,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: buildShowStock(index, state),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
>>>>>>> Stashed changes
                          ),
                          const Spacer(),
                          buildInformationBant(state.currentIndex!, state),
                        ],
                      ),
                    ))),
          ), /*  Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Center(
              child: WidgetsToImage(
                controller: controllers[index],
                child: AspectRatio(
                  aspectRatio: state.aspectRatio!,
                  child: InkWell(
                    onDoubleTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoEditView(
                                    item: photoList![index],
                                  )));
                      setState(() {});
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: NetworkImage(
                            photoList![index]
                                    .colors?[photoList![index].currentIndex!]
                                    .colorImage ??
                                '',
                          ),
                          onError: (error, stackTrace) =>
                              const AssetImage('assets/could_not_load_img.jpg'),
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                state.addVariants == true
                                    ? addVariants(index, state)
                                    : Container(),
                                state.showLogo == true
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                          width: 80,
                                          child: Image.network(
                                            state.companyLogo ?? '',
                                            loadingBuilder: (context, child,
                                                    loadingProgress) =>
                                                loadingProgress == null
                                                    ? child
                                                    : const CircularProgressIndicator(),
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container();
                                            },
                                          ),
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                            const Spacer(),
                            buildInformationBant(index, state),
                          ],
                        ),
                        state.addVariants == true
                            ? addVariants(index, state)
                            : Container(),
                        buildInformationBant(index, state),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),*/
        ),
      ),
    );
  }

  Widget buildProduct2(PhotoPageState state) {
    double calculatedWidth =
        MediaQuery.of(context).size.height * 0.6 * state.aspectRatio!;

    return SizedBox(
      width: calculatedWidth,
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: Center(
              child: WidgetsToImage(
                controller: controllers[index],
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: InkWell(
                    onDoubleTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoEditView(
                                    item: photoList![index],
                                  )));
                      setState(() {});
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          image: NetworkImage(photoList![index]
                                  .colors?[photoList![index].currentIndex!]
                                  .colorImage ??
                              ''),
                          onError: (error, stackTrace) =>
                              const AssetImage('assets/could_not_load_img.jpg'),
                        ),
                      ),
                      child: Column(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    state.showLogo == true
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              width: 80,
                                              child: Image.network(
                                                state.companyLogo ?? '',
                                                loadingBuilder: (context, child,
                                                        loadingProgress) =>
                                                    loadingProgress == null
                                                        ? child
                                                        : const CircularProgressIndicator(),
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(Icons
                                                          .upload_file_outlined));
                                                },
                                              ),
                                            ))
                                        : Container()
                                  ],
                                ),
                                const Spacer(),
                                /* state.addVariants == true
                                    ? addVariants(index, state)
                                    : Container(),*/
                                // buildInformationBant(index, state),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

  SingleChildScrollView addVariants(int index, PhotoPageState state) {
    var length = photoList![index].colors!.length - 1;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: photoList![index]
            .colors!
            .where((element) =>
                element !=
                    photoList![index]
                        .colors![photoList![index].currentIndex!] &&
                element.colorImage.isNotNullOrNoEmpty)
            .toList()
            .sublist(0, length >= 4 ? 4 : length)
            .map((e) => Padding(
                padding: const EdgeInsets.only(left: 4.0, top: 4, bottom: 4),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      photoList![index].currentIndex =
                          photoList![index].colors!.indexOf(e);
                    });
                  },
                  child: Container(
                      alignment: Alignment.topRight,
                      width: (MediaQuery.of(context).size.width /
                              (length >= 4 ? 4 : 3)) -
                          4,
                      height: 100,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(e.colorImage ?? '')),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(2)),
                      child: Text(
                        state.showStock == true ? '${e.stock}' : '',
                        style: const TextStyle(
                            fontSize: 12,
                            textBaseline: TextBaseline.alphabetic,
                            fontWeight: FontWeight.bold,
                            color: ColorConstants.mtPrimary),
                      )),
                )))
            .toList(),
      ),
    );
  }

  Container buildInformationBant(int index, PhotoPageState state) {
    return Container(
      height: 60,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
<<<<<<< Updated upstream
                SizedBox(
                  child: Text("#${widget.photoList![index].itemCode}",
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ),
=======
                buildShowPrice(index, state),
>>>>>>> Stashed changes
                SizedBox(
                  child: Text(
                    photoList![index].itemDescription ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            const Spacer(),
            state.showLogo == true
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 80,
                      alignment: Alignment.centerRight,
                      child: Image.network(
                        state.companyLogo ?? '',
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const CircularProgressIndicator(),
                        errorBuilder: (context, error, stackTrace) {
                          return Container();
                        },
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Text buildShowPrice(int index, PhotoPageState state) {
    if (state.showPrice == true && state.showBasePrice == false) {
      return Text(
        '${widget.photoList![index].basePrice} ${widget.photoList![index].basePriceCurrencyCode} / Adet',
        style: const TextStyle(
            color: ColorConstants.mtPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold),
      );
    } else if (state.showPrice == true && state.showBasePrice == true) {
      return Text(
        '${widget.photoList![index].tRYPrice} TRY / ${_translations[_currentLanguage]['piece']} ',
        style: const TextStyle(
            color: ColorConstants.mtPrimary,
            fontSize: 13,
            fontWeight: FontWeight.bold),
      );
    }
    return const Text("");
  }

  Text buildShowStock(int index, PhotoPageState state) {
    if (state.showStock == true) {
      return Text(
          "${_translations[_currentLanguage]['stock']} ${widget.photoList![index].colors?[photoList![index].currentIndex!].stock}",
          style: const TextStyle(
              color: ColorConstants.mtPrimary,
              fontSize: 13,
              fontWeight: FontWeight.bold));
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
