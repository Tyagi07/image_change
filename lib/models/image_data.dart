class ImageData {
  final String fileName;
  final int originalSize;
  String? webpUrl;
  int? convertedSize;

  ImageData({
    required this.fileName,
    required this.originalSize,
    this.webpUrl,
    this.convertedSize,
  });
}
