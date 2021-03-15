import 'dart:io';

import 'package:flutter/material.dart';

import '../data/data.dart';

class ImageWidget extends StatelessWidget {
  final File imageFile;
  final String imageUrl;
  final double width;
  final double height;
  final String placeHolderImage;

  ImageWidget(
      {@required this.imageUrl,
      this.imageFile,
      this.width,
      this.height,
      this.placeHolderImage});

  @override
  Widget build(BuildContext context) {
    return imageFile != null
        ? Image.file(
            imageFile,
            height: height,
            width: width,
            fit: BoxFit.cover,
          )
        : imageUrl == null || imageUrl.isEmpty
            ? Image.asset(
                placeHolderImage,
                height: height,
                width: width,
                fit: BoxFit.cover,
              )
            : FadeInImage.assetNetwork(
                placeholder: placeHolderImage,
                image: "${AppUrls.IMAGE_BASE_URL}$imageUrl",
                height: height,
                width: width,
                fit: BoxFit.cover,
              );
  }
}
