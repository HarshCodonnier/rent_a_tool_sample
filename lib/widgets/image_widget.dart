import 'package:flutter/material.dart';

import '../data/data.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final String placeHolderImage;

  ImageWidget(
      {@required this.imageUrl,
      this.width,
      this.height,
      this.placeHolderImage});

  @override
  Widget build(BuildContext context) {
    return imageUrl == null || imageUrl.isEmpty
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
