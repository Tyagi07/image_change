import 'package:flutter/material.dart';
import 'package:image_change/viewmodels/image_viewmodel.dart';
import 'package:provider/provider.dart';

class ImageConverterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WebP Converter'),
      ),
      body: Center(
        child: ChangeNotifierProvider(
          create: (_) => ImageConverterViewModel(),
          child: Builder(
            builder: (context) {
              final viewModel = context.watch<ImageConverterViewModel>();

              return Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      icon: Icon(Icons.upload_file),
                      label: Text(viewModel.isLoading ? 'Converting...' : 'Select Image'),
                      onPressed: viewModel.isLoading ? null : viewModel.pickAndConvertImage,
                    ),
                    if (viewModel.isLoading) ...[
                      SizedBox(height: 20),
                      CircularProgressIndicator(),
                    ],
                    if (viewModel.error != null) ...[
                      SizedBox(height: 20),
                      Text(
                        viewModel.error!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                    if (viewModel.imageData != null) ...[
                      SizedBox(height: 20),
                      Text('Original Size: ${(viewModel.imageData!.originalSize / 1024).toStringAsFixed(2)} KB'),
                      Text('Converted Size: ${(viewModel.imageData!.convertedSize! / 1024).toStringAsFixed(2)} KB'),
                      // Text('Compression Ratio: ${(viewModel.imageData!.convertedSize! / viewModel.imageData!.originalSize * 100).toStringAsFixed(1)}%'),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}