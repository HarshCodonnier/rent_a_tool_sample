import 'package:flutter/material.dart';

import '../extras/extensions.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String text;
  final String imageName;
  final TextInputType inputType;
  final FormFieldValidator<String> validator;
  final FormFieldSetter<String> onSaved;

  CustomTextField(
      {this.controller,
      this.text,
      this.imageName,
      this.inputType,
      this.validator,
      this.onSaved});

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Color(0xFFF3DDD5), blurRadius: 10)],
      ),
      child: Card(
        shape: 8.cardRadius(),
        child: TextFormField(
          controller: widget.controller,
          style: 16.textFieldText(),
          cursorColor: Theme.of(context).textSelectionTheme.cursorColor,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: widget.text,
            prefixIcon: widget.imageName.textFieldPrefixIcon(),
          ),
          keyboardType:
              widget.inputType == null ? TextInputType.text : widget.inputType,
          validator: widget.validator,
          onSaved: widget.onSaved,
        ),
        shadowColor: Color(0xFFFCF1DE),
      ),
    );
  }
}
