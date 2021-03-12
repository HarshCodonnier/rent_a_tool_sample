import 'package:flutter/material.dart';

import '../extras/extras.dart';

class EditProfileTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType textInputType;
  final int maxLines;
  final double vContentPadding;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  EditProfileTextField(
      {@required this.hintText,
      @required this.controller,
      this.textInputType,
      this.maxLines,
      this.vContentPadding,
      this.validator,
      this.onSaved});

  @override
  _EditProfileTextFieldState createState() => _EditProfileTextFieldState();
}

class _EditProfileTextFieldState extends State<EditProfileTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Color(0xFFE7E7E7),
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        validator: widget.validator,
        onSaved: widget.onSaved,
        controller: widget.controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: textFieldHintStyle,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical:
                  widget.vContentPadding == null ? 0 : widget.vContentPadding),
        ),
        keyboardType: widget.textInputType == null
            ? TextInputType.text
            : widget.textInputType,
        style: textFieldStyle,
        maxLines: widget.maxLines,
      ),
    );
  }
}
