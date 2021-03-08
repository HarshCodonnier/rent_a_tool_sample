import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_tool_sample/data/request_notifier.dart';
import 'package:rent_a_tool_sample/extras/shared_pref.dart';
import 'package:rent_a_tool_sample/models/user_item.dart';
import 'package:rent_a_tool_sample/widgets/custom_text_field.dart';

import '../extras/extensions.dart';
import '../screens/registration_page.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/gradient_raised_button.dart';
import '../widgets/password_text_field.dart';
import '../widgets/sign_up_button.dart';
import 'dashboard.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double _mediaQuerySizeH;
  double _mediaQuerySizeW;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  RequestNotifier _auth;
  bool _loading = false;

  void _onLoginClicked() {
    setState(() {
      _loading = true;
      _auth
          .login(_email.text.toString(), _password.text.toString())
          .then((response) {
        _loading = false;
        if (response["status"]) {
          print(response["message"]);
          preferences.putBool(SharedPreference.IS_LOGGED_IN, true);
          UserItem userItem = UserItem.fromJson(response["data"]);
          Provider.of<UserProvider>(context, listen: false)
              .setUserItem(userItem);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Dashboard(), maintainState: false));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response["message"])));
        }
      });
    });
  }

  void _onForgotPasswordClicked() {
    setState(() {
      print("clicked");
    });
  }

  void _onSignUpClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _mediaQuerySizeH = MediaQuery
        .of(context)
        .size
        .height;
    _mediaQuerySizeW = MediaQuery
        .of(context)
        .size
        .width;
    _auth = Provider.of<RequestNotifier>(context);

    return Scaffold(
      body: Stack(children: [
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
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
                  vertical: _mediaQuerySizeH * 0.01, horizontal: 20),
              child: Column(
                children: [
                  "assets/images/logo.png".appLogo(
                      w: _mediaQuerySizeW * 0.2, h: _mediaQuerySizeH * 0.2),
                  (_mediaQuerySizeH * 0.01).addHSpace(),
                  Text(
                    "Sign in",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText1,
                  ),
                  (_mediaQuerySizeH * 0.06).addHSpace(),
                  CustomTextField(
                    controller: _email,
                    text: "Email Address",
                    imageName: "assets/images/email.png",
                    inputType: TextInputType.emailAddress,
                  ),
                  5.addHSpace(),
                  PasswordTextField(_password, "Password"),
                  (_mediaQuerySizeH * 0.04).addHSpace(),
                  GradientRaisedButton("Sign in", _onLoginClicked),
                  CustomTextButton(
                      "Forgot Password?", _onForgotPasswordClicked),
                  (_mediaQuerySizeH * 0.12).addHSpace(),
                  "- OR -".buttonText(isBold: false, color: Color(0xFF3E454F)),
                  (_mediaQuerySizeH * 0.02).addHSpace(),
                  SignUpButton(
                      text: "Don't have an Account ?",
                      subText: " Sign up",
                      onSignUpClicked: _onSignUpClicked)
                ],
              ),
            ),
          ),
        ),
        _loading
            ? Center(child: CircularProgressIndicator.adaptive(strokeWidth: 5))
            : Container()
      ]),
    );
  }
}
