import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  final TextEditingController search;
  final Function onSubmit;

  SearchTextField(this.search, this.onSubmit);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: (value) => onSubmit(value),
      controller: search,
      decoration: InputDecoration(
        prefixIcon: Image.asset("assets/images/search.png"),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(23),
            borderSide: BorderSide.none),
        fillColor: Colors.white,
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 5),
        labelText: "Search",
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: TextStyle(
          color: Color(0xFFCDCDCD),
        ),
      ),
    );
  }
}
