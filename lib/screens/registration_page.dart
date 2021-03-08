import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_tool_sample/data/request_notifier.dart';
import 'package:rent_a_tool_sample/extras/shared_pref.dart';
import 'package:rent_a_tool_sample/models/user_item.dart';
import 'package:rent_a_tool_sample/screens/dashboard.dart';

import '../extras/extensions.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_raised_button.dart';
import '../widgets/password_text_field.dart';
import '../widgets/sign_up_button.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  double _mediaQuerySizeH;
  double _mediaQuerySizeW;
  RequestNotifier _auth;
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();

  void _onSingInClicked() {
    Navigator.pop(context);
  }

  void _onSingUpClicked() {
    _auth
        .register("${_firstName.text.toString()} ${_lastName.text.toString()}",
            _email.text.toString(), _password.text.toString())
        .then((response) {
      if (response["status"] as bool) {
        preferences.putBool(SharedPreference.IS_REGISTERED, true);
        UserItem userItem = UserItem.fromJson(response["data"]);
        Provider.of<UserProvider>(context, listen: false).setUserItem(userItem);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        print(response["message"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _mediaQuerySizeH = MediaQuery.of(context).size.height;
    _mediaQuerySizeW = MediaQuery.of(context).size.width;
    _auth = Provider.of<RequestNotifier>(context);

    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0xFFFEF8F6),
        ),
        Positioned(
          width: _mediaQuerySizeW,
          child: Image.asset(
            "assets/images/background.png",
            fit: BoxFit.fill,
            height: _mediaQuerySizeH * 0.25,
          ),
          bottom: 0,
        ),
        SingleChildScrollView(
          child: SafeArea(
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.symmetric(
                  vertical: _mediaQuerySizeH * 0.04, horizontal: 20),
              child: Column(children: [
                "assets/images/logo.png".appLogo(
                    w: _mediaQuerySizeW * 0.2, h: _mediaQuerySizeH * 0.15),
                Text(
                  "Sign up",
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                (_mediaQuerySizeH * 0.04).addHSpace(),
                CustomTextField(
                  controller: _firstName,
                  text: "First Name",
                  imageName: "assets/images/user.png",
                ),
                5.addHSpace(),
                CustomTextField(
                  controller: _lastName,
                  text: "Last Name",
                  imageName: "assets/images/user.png",
                ),
                5.addHSpace(),
                CustomTextField(
                  controller: _email,
                  text: "Email Address",
                  imageName: "assets/images/email.png",
                  inputType: TextInputType.emailAddress,
                ),
                5.addHSpace(),
                PasswordTextField(text: "Password"),
                5.addHSpace(),
                PasswordTextField(text: "Confirm Password"),
                (_mediaQuerySizeH * 0.03).addHSpace(),
                GradientRaisedButton("Sign up", _onSingUpClicked),
                (_mediaQuerySizeH * 0.03).addHSpace(),
                "- OR -".buttonText(isBold: false, color: Color(0xFF3E454F)),
                (_mediaQuerySizeH * 0.02).addHSpace(),
                SignUpButton(
                    text: "Already have an Account ?",
                    subText: " Sign in",
                    onButtonClicked: _onSingInClicked)
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
