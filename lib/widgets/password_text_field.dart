import 'package:flutter/material.dart';

import '../extras/extensions.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  PasswordTextField({this.controller, this.text, this.validator, this.onSaved});

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isPasswordShow = false;
  ThemeData _theme;

  @override
  Widget build(BuildContext context) {
    _theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Color(0xFFF3DDD5), blurRadius: 10)],
      ),
      child: TextFormField(
        controller: widget.controller,
        style: 16.textFieldText(),
        obscureText: !_isPasswordShow,
        cursorColor: _theme.textSelectionTheme.cursorColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: widget.text,
          prefixIcon: "assets/images/password.png".textFieldPrefixIcon(),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordShow ? Icons.visibility_off : Icons.visibility,
              color: Color(0xFF8B8F95),
            ),
            onPressed: () {
              setState(() {
                _isPasswordShow = !_isPasswordShow;
              });
            },
          ),
        ),
        keyboardType: TextInputType.text,
        validator: widget.validator,
        onSaved: widget.onSaved,
      ),
    );
  }
}
