import 'package:flutter/material.dart';

class SocialSignInButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function onClick;

  SocialSignInButton({this.icon, this.color, this.onClick});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: color, width: 2),
          ),
        ),
        overlayColor: MaterialStateProperty.all(
          color.withAlpha(50),
        ),
      ),
      onPressed: onClick,
      child: Row(
        children: [Icon(icon, color: color)],
      ),
    );
  }
}
