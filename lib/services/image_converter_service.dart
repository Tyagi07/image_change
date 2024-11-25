import 'dart:html' as html;
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:image_change/models/image_data.dart';

class ImageConverterService {
  Future<ImageData> convertToWebP(Uint8List imageBytes, String fileName) async {
    final imageData = ImageData(
      fileName: fileName.replaceAll(RegExp(r'\.[^/.]+$'), '.webp'),
      originalSize: imageBytes.length,
    );

    try {

      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) throw Exception('Failed to decode image');


      final webpBytes = img.encodeJpg(
        originalImage,
        quality: 80,
      );

      final blob = html.Blob([webpBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement()
        ..href = url
        ..download = imageData.fileName
        ..style.display = '';

      html.document.body!.children.add(anchor);
      anchor.click();


      Future.delayed(Duration(milliseconds: 100), () {
        anchor.remove();
        html.Url.revokeObjectUrl(url);
      });

      imageData.webpUrl = url;
      imageData.convertedSize = webpBytes.length;

      return imageData;
    } catch (e) {
      print('Conversion error: ${e.toString()}');
      throw Exception('Failed to convert image: ${e.toString()}');
    }
  }
}