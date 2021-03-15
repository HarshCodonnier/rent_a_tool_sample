import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../extras/extras.dart';

class ContainerRaisedButton extends StatelessWidget {
  const ContainerRaisedButton({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required String text,
  })  :
        _formKey = formKey,
        _text = text,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final String _text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: secondaryColor,
      ),
      child: TextButton(
        onPressed: () {
          if (_formKey.currentState.validate()) {
            print("Update");
          } else {
            print("Update");
          }
        },
        child: Container(
          child: Text(_text,
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
