import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension sizedBox on double {
  addHSpace() {
    return SizedBox(
      height: this,
    );
  }

  addWSpace() {
    return SizedBox(
      width: this,
    );
  }
}

extension textSize on int {
  textFieldText() {
    return GoogleFonts.muli(
        fontWeight: FontWeight.normal, fontSize: this.toDouble());
  }

  cardRadius() {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(this.toDouble()));
  }

  addHSpace() {
    return SizedBox(
      height: this.toDouble(),
    );
  }
}

extension text on String {
  appLogo({double w, double h}) {
    return Image.asset(
      this,
      width: w,
      height: h,
    );
  }

  headerText() {
    return Text(
      this,
      style: GoogleFonts.muli(
        fontWeight: FontWeight.bold,
        color: Color(0xFF3E454F),
        fontSize: 20,
      ),
    );
  }

  rowTitleText() {
    return Text(
      this,
      style: GoogleFonts.openSans(
        fontWeight: FontWeight.w600, // -> semiBold
        color: Colors.black,
        fontSize: 13,
      ),
    );
  }

  rowSubTitleText() {
    return Text(
      this,
      style: GoogleFonts.openSans(
        fontWeight: FontWeight.w600, // -> semiBold
        color: Color(0xFF9E9E9E),
        fontSize: 9,
      ),
    );
  }

  rowDetailText([int maxLines]) {
    return Text(
      this,
      style: GoogleFonts.openSans(
        color: Colors.black,
        fontSize: 9,
      ),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
  }

  buttonText({bool isBold = true, Color color = Colors.white}) {
    return Text(
      this,
      style: GoogleFonts.muli(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        color: color,
      ),
    );
  }

  textFieldPrefixIcon() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Image.asset(
        this,
        height: 5,
        width: 5,
      ),
    );
  }

  errorText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Text(
            this,
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}

class Routes {
  static const String defaultRoute = "/";
  static const String registrationRoute = "/registration";
  static const String dashboardRoute = "/dashboard";
}

var cardShadowColor = Colors.black38;
var placeHolderImage = "assets/images/placeholder.png";
var arrowImage = "assets/images/arrow.png";