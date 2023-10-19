import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tk_photo/feature/home/photo/photo_provider.dart';
import 'package:tk_photo/product/constant/app_color.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../../product/constant/app_process_enum.dart';

class ProductDetailPhotoView extends ConsumerStatefulWidget {
  const ProductDetailPhotoView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductDetailPhotoViewState();
}

class _ProductDetailPhotoViewState
    extends ConsumerState<ProductDetailPhotoView> {
  WidgetsToImageController? widgetsToImageController;

  int currentLength = 10;

  List<WidgetsToImageController> controllers = [];
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      for (var i = 0; i < currentLength; i++) {
        print("initState $i");
        controllers.add(WidgetsToImageController());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var photoStateProvider = ref.watch(productPhotoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TK Photo Oluşturma',
            style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: photoStateProvider.appState == ApppProcessStatus.loading
                ? const Center(
                    child: CircularProgressIndicator.adaptive(),
                  )
                : Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return const Card(
                                elevation: 3.0,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      child: AspectRatio(
                                        aspectRatio: 4 / 5,
                                        child: Image(
                                          image:
                                              AssetImage('images/maggie.jpg'),
                                          fit: BoxFit.fill, // use this
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                          },
                          itemCount: 10,
                        ),
                      ),
                      // widgetToImageIf(context, photoStateProvider),
                      //setting button
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              List<Uint8List> images = [];
                              List<XFile> files = [];

                              await Future.forEach<WidgetsToImageController>(
                                  controllers, (e) async {
                                print(e.toString());

                                await e.capture().then((value) async {
                                  files.add(XFile.fromData(
                                    Uint8List.fromList(value!),
                                    name: photoStateProvider.itemCodeDesc
                                        .toString(),
                                    mimeType: 'image/png',
                                  ));
                                  print("files${files.length}");
                                  images.add(Uint8List.fromList(value));
                                  print(images.length);
                                });
                              });

                              Share.shareXFiles(files);
                            },
                            child: const Text('Resmi Kaydet',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),

                      const Divider(),
                      //Seeings with switch button
                      Padding(
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
                                  value:
                                      photoStateProvider.addVariants ?? false,
                                  onChanged: (value) {
                                    ref
                                        .read(productPhotoProvider.notifier)
                                        .changeStatus(
                                            AppPropertiesEnum.addVariants,
                                            value);
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
                                  value: photoStateProvider.showLogo ?? false,
                                  onChanged: (value) {
                                    ref
                                        .read(productPhotoProvider.notifier)
                                        .changeStatus(
                                            AppPropertiesEnum.showLogo, value);
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
                                  value: photoStateProvider.showPrice ?? false,
                                  onChanged: (value) {
                                    ref
                                        .read(productPhotoProvider.notifier)
                                        .changeStatus(
                                            AppPropertiesEnum.showPrice, value);
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
                                  value:
                                      photoStateProvider.showBasePrice ?? false,
                                  onChanged: (value) {
                                    ref
                                        .read(productPhotoProvider.notifier)
                                        .changeStatus(
                                            AppPropertiesEnum.showBasePrice,
                                            value);
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
                                  value: photoStateProvider.showStock ?? false,
                                  onChanged: (value) {
                                    ref
                                        .read(productPhotoProvider.notifier)
                                        .changeStatus(
                                            AppPropertiesEnum.showStock, value);
                                  },
                                  activeTrackColor: ColorConstants.mtPrimary,
                                  activeColor: Colors.white,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Seçilen Ürün Stok Göster',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                Switch(
                                  value: photoStateProvider.showOnlyOneStock ??
                                      false,
                                  onChanged: (value) {
                                    ref
                                        .read(productPhotoProvider.notifier)
                                        .changeStatus(
                                            AppPropertiesEnum.showOnlyOneStock,
                                            value);
                                  },
                                  activeTrackColor: ColorConstants.mtPrimary,
                                  activeColor: Colors.white,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }

  Column widgetToImageIf(BuildContext context, PhotoPageState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: 100,
              child: Row(
                  children: state.colors!
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                ref
                                    .read(productPhotoProvider.notifier)
                                    .changeIndex(state.colors?.indexOf(e) ?? 0);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: state.colors?.indexOf(e) ==
                                              state.currentIndex
                                          ? Colors.red
                                          : Colors.grey,
                                      width: 1),
                                  color: Colors.white,
                                ),
                                height: 75,
                                width: 75,
                                child: Image.network(e.colorImage.toString()),
                              ),
                            ),
                          ))
                      .toList())),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.height * 0.9,
              child: Row(
                children: controllers
                    .map((e) => Card(
                              elevation: 3.0,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: const AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Image(
                                        image: AssetImage('images/maggie.jpg'),
                                        fit: BoxFit.fill, // use this
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ) /*AspectRatio(
                        aspectRatio: 4 / 5,
                        child: WidgetsToImage(
                          controller: controllers[controllers.indexOf(e)],
                          child: Container(
                            width: MediaQuery.of(context).size.height * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.grey, width: 2),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.height *
                                      0.40,
                                  width: MediaQuery.of(context).size.height *
                                      0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        state.photoList![state.currentIndex!]
                                            .toString(),
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      state.showLogo ?? false
                                          ? SizedBox(
                                              width: 75,
                                              height: 75,
                                              child: Image.network(
                                                state.companyLogo.toString(),
                                              ),
                                            )
                                          : Container(
                                              child: Text(controllers
                                                  .indexOf(e)
                                                  .toString()),
                                            )
                                    ],
                                  ),
                                ),
                                (state.addVariants ?? false)
                                    ? const Divider()
                                    : Container(),
                                (state.addVariants ?? false)
                                    ? Row(
                                        children: state.photoList!
                                            .where((element) =>
                                                element !=
                                                state.photoList![
                                                    state.currentIndex!])
                                            .map(
                                              (e) => Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        right: 8),
                                                child: Container(
                                                    decoration:
                                                        const BoxDecoration(),
                                                    height: 100,
                                                    width: 100,
                                                    child: Image.network(
                                                      e.toString(),
                                                    )),
                                              ),
                                            )
                                            .toList())
                                    : Container(),
                                Container(
                                    height:
                                        MediaQuery.of(context).size.height *
                                            0.08,
                                    width:
                                        MediaQuery.of(context).size.height *
                                            0.9,
                                    color: Colors.grey.withOpacity(0.5),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          // title, price, logo

                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                state.itemCode.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Text(
                                                state.itemCodeDesc.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),

                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              (state.showStock ?? false)
                                                  ? Text(
                                                      (state.showOnlyOneStock ??
                                                              false)
                                                          ? '${state.colors![state.currentIndex!].colorDescription.toString()} - ${state.colors![state.currentIndex!].stock.toString()}'
                                                          : 'Stok ${state.stock.toString()}',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                    )
                                                  : Container(),
                                              (state.showPrice ?? false)
                                                  ? Text(
                                                      (state.showBasePrice ??
                                                              false)
                                                          ? '${state.basePrice} ${state.basePriceCurrency}'
                                                          : '${state.tryPrice} ${state.tryPriceCurrency}',
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w600),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ), */
                        )
                    .toList(),
              ),
            )
          ],
        ),
      ],
    );
  }
}
