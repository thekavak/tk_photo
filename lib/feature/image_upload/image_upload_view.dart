import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:tk_photo/core/model/upload_file_model.dart';

import '../../core/model/product_list_model.dart';
import '../../service/network_manager.dart';

// ignore: must_be_immutable
class ImageUploadView extends ConsumerStatefulWidget {
  ProductListModel? item;

  ImageUploadView({super.key, required this.item});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ImageUploadViewState();
}

class _ImageUploadViewState extends ConsumerState<ImageUploadView> {
  List<UploadedFile> uploadedFileList = [];
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool _isLoading = false;
  List<PlatformFile>? _paths;
  String? fileName;
  late final NetworkManager _request;

  @override
  void initState() {
    super.initState();
    _request = NetworkManager();
  }

  void _logException(String message) {
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  imageUploadApi(UploadedFile choosenFilePath) async {
    try {
      //print("imageUploadApi");
      File file = File(choosenFilePath.path);
      String fileName = choosenFilePath.name;
      //print(fileName);
      var formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path, filename: fileName),
      });

      var response = await _request.uploadProductImage(formData: formData);
      //print("response message${response?.message}");
      //print(response?.url);
      if (response == null) {
        _logException('Dosya yüklenemedi');
        return;
      }
      if (response.status == true) {
        setState(() {
          choosenFilePath.status = true;
          widget.item?.colors
              ?.firstWhere(
                  (element) => element.colorCode == choosenFilePath.colorCode)
              .colorImage = response.url ?? '';
        });
      } else {
        _logException('Dosya yüklenemedi');
        setState(() {
          choosenFilePath.status = false;
        });
      }
    } catch (e) {
      //print(e);
    }
  }

  pickFiles({required String itemCode, required String colorCode}) async {
    try {
      _isLoading = true;
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      ))
          ?.files;

      if (_paths != null) {
        List<UploadedFile> files = _paths
                ?.map((e) => UploadedFile(
                    name: e.name,
                    path: e.path!,
                    itemCode: itemCode,
                    colorCode: colorCode,
                    status: false,
                    loading: false,
                    size: e.size))
                .toList() ??
            [];
        setState(() {
          uploadedFileList.addAll(files);
        });
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      fileName = _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _isLoading = false;
    });
  }

  TextButton getUploadButton(UploadedFile item, BuildContext context) {
    return TextButton(
      onPressed: () async {
        setState(() {
          item.loading = true;
        });
        await imageUploadApi(item);

        item.loading = false;
      },
      style: TextButton.styleFrom(
          padding: const EdgeInsets.all(0), alignment: Alignment.centerRight),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Yükle",
          style: TextStyle(
              color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w600),
          textAlign: TextAlign.end,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              const Text('Image Upload', style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Text(
                  widget.item?.itemCode ?? '',
                ),
                Text(
                  widget.item?.itemDescription ?? '',
                ),
                const SizedBox(height: 20),
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        trailing: SizedBox(
                          width: 100,
                          child: Image.network(
                            widget.item?.colors?[index].colorImage ?? '',
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : const CircularProgressIndicator(),
                            errorBuilder: (context, error, stackTrace) {
                              return IconButton(
                                  onPressed: () {
                                    pickFiles(
                                        itemCode: widget.item?.itemCode ?? '',
                                        colorCode: widget.item?.colors?[index]
                                                .colorCode ??
                                            '');
                                  },
                                  icon: const Icon(Icons.upload_file_outlined));
                            },
                          ),
                        ),
                        title:
                            Text(widget.item?.colors?[index].colorCode ?? ''),
                        subtitle: Text(
                            widget.item?.colors?[index].colorDescription ?? ''),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: widget.item?.colors?.length ?? 0),
                Builder(
                  builder: (BuildContext context) => _isLoading == true
                      ? const Padding(
                          padding: EdgeInsets.only(bottom: 20.0, top: 20),
                          child: CircularProgressIndicator(),
                        )
                      : uploadedFileList.isNotEmpty
                          ? Container(
                              padding:
                                  const EdgeInsets.only(bottom: 20.0, top: 20),
                              height: MediaQuery.of(context).size.height * 0.50,
                              child: Scrollbar(
                                child: ListView.separated(
                                  itemCount: uploadedFileList.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 24.0, right: 24, top: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.60,
                                            child: Text(
                                                uploadedFileList[index].name,
                                                overflow:
                                                    TextOverflow.ellipsis),
                                          ),
                                          uploadedFileList[index].status ==
                                                  false
                                              ? SizedBox(
                                                  height: 35,
                                                  child: uploadedFileList[index]
                                                              .loading ==
                                                          false
                                                      ? getUploadButton(
                                                          uploadedFileList[
                                                              index],
                                                          context)
                                                      : const CircularProgressIndicator(),
                                                )
                                              : const Text('Yüklendi')
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          const Divider(),
                                ),
                              ),
                            )
                          : Container(),
                ),
              ],
            ),
          ),
        ));
  }
}
