import 'package:flutter/material.dart';

import '../extras/extensions.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final Function onClicked;

  CustomTextButton(this.text, this.onClicked);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onClicked,
      style: ButtonStyle(
          overlayColor:
              MaterialStateProperty.all(Theme.of(context).splashColor)),
      child: text.buttonText(isBold: false, color: Color(0xFF3E454F)),
    );
  }
}
