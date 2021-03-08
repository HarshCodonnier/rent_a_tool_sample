import 'package:flutter/material.dart';

import '../extras/extensions.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final String imageName;
  TextInputType inputType = TextInputType.text;

  CustomTextField({this.controller, this.text, this.imageName, this.inputType});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Color(0xFFF3DDD5), blurRadius: 10)],
      ),
      child: Card(
        shape: 8.cardRadius(),
        child: TextField(
          controller: controller,
          style: 12.textFieldText(),
          cursorColor: Theme.of(context).cursorColor,
          decoration: InputDecoration(
              border: InputBorder.none,
              labelText: text,
              prefixIcon: imageName.textFieldPrefixIcon()),
          keyboardType: inputType,
        ),
        shadowColor: Color(0xFFFCF1DE),
      ),
    );
  }
}
