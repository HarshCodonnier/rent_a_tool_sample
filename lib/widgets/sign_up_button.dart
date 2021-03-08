import 'package:flutter/material.dart';

import '../extras/extensions.dart';

class SignUpButton extends StatelessWidget {
  final String text;
  final String subText;
  final Function onButtonClicked;

  SignUpButton({this.text, this.subText, this.onButtonClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text.buttonText(isBold: false, color: Color(0xFF3E454F)),
            subText.buttonText(isBold: false, color: Color(0xFFFE5210))
          ],
        ),
        onPressed: onButtonClicked,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              width: 1,
              color: Color(0xFFFE5210),
            ),
          ),
        ),
      ),
    );
  }
}
