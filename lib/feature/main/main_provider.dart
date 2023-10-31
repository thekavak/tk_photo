import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mainProvider = ChangeNotifierProvider<MainNotifier>((ref) {
  return MainNotifier();
});

class MainNotifier extends ChangeNotifier {
  bool _isPhotoUploadMode = false;

  bool get isPhotoUploadMode => _isPhotoUploadMode;

  void changePhotoUploadMode() {
    _isPhotoUploadMode = !_isPhotoUploadMode;

    notifyListeners();
  }
}
