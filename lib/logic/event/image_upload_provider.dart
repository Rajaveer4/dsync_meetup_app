import 'dart:io';
import 'package:flutter/material.dart';

class ImageUploadProvider with ChangeNotifier {
  List<File> _images = [];
  bool _isUploading = false;
  double _uploadProgress = 0;

  List<File> get images => _images;
  bool get isUploading => _isUploading;
  double get uploadProgress => _uploadProgress;

  void addImages(List<File> newImages) {
    _images.addAll(newImages);
    notifyListeners();
  }

  void removeImage(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  void setUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  void updateProgress(double progress) {
    _uploadProgress = progress;
    notifyListeners();
  }

  void reset() {
    _images = [];
    _isUploading = false;
    _uploadProgress = 0;
    notifyListeners();
  }
}