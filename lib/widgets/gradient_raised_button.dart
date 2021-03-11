import 'package:flutter/material.dart';

import '../extras/extensions.dart';

class GradientRaisedButton extends StatelessWidget {
  final String text;
  final Function onClicked;

  GradientRaisedButton(this.text, this.onClicked);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: mediaQueryW(context),
      height: 40.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF9BE00), Color(0xFFFF4612)]),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(0.0, 1.5),
            blurRadius: 1.5,
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onClicked,
            child: Center(
              child: text.buttonText(),
            )),
      ),
    );
  }
}
