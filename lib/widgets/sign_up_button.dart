import 'package:flutter/material.dart';

import '../extras/extensions.dart';

class SignUpButton extends StatelessWidget {
  final String text;
  final String subText;
  final Function onSignUpClicked;

  SignUpButton({this.text, this.subText,this.onSignUpClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: RaisedButton(
        color: Colors.white,
        onPressed: onSignUpClicked,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text.buttonText(isBold: false, color: Color(0xFF3E454F)),
            subText.buttonText(isBold: false, color: Color(0xFFFE5210))
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(width: 1, color: Color(0xFFFE5210)),
        ),
      ),
    );
  }
}
