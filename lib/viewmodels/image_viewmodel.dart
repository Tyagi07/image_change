import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_change/models/image_data.dart';
import 'package:image_change/services/image_converter_service.dart';

class ImageConverterViewModel extends ChangeNotifier {
  final ImageConverterService _service = ImageConverterService();

  ImageData? _imageData;
  bool _isLoading = false;
  String? _error;

  ImageData? get imageData => _imageData;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> pickAndConvertImage() async {
    if (!kIsWeb) {
      _error = 'This feature is only available on web';
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp','WebP'],
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        throw Exception('No image selected');
      }

      final file = result.files.first;
      if (file.bytes == null) {
        throw Exception('Failed to read image data');
      }

      _imageData = await _service.convertToWebP(
        file.bytes!,
        file.name,
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _imageData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}