import 'dart:io';

import 'package:flutter/material.dart';

import '../data/data.dart';

class ImageWidget extends StatelessWidget {
  final File imageFile;
  final String imageUrl;
  final double width;
  final double height;
  final String placeHolderImage;
  final bool isUserProfile;

  ImageWidget(
      {@required this.imageUrl,
      this.imageFile,
      this.width,
      this.height,
      this.placeHolderImage,
      this.isUserProfile});

  @override
  Widget build(BuildContext context) {
    if (imageFile != null) {
      return Image.file(
        imageFile,
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
    } else {
      if (imageUrl == null || imageUrl.isEmpty) {
        return Image.asset(
          placeHolderImage,
          height: height,
          width: width,
          fit: BoxFit.cover,
        );
      } else {
        print(
            "${isUserProfile != null && isUserProfile ? AppUrls.USER_IMAGE_BASE_URL : AppUrls.IMAGE_BASE_URL}$imageUrl");
        return FadeInImage.assetNetwork(
          placeholder: placeHolderImage,
          image:
              "${isUserProfile != null && isUserProfile ? AppUrls.USER_IMAGE_BASE_URL : AppUrls.IMAGE_BASE_URL}$imageUrl",
          height: height,
          width: width,
          fit: BoxFit.cover,
        );
      }
    }
  }
}
