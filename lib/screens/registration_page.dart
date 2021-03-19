import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/request_notifier.dart';
import '../extras/extras.dart';
import '../models/user_item.dart';
import '../widgets/widgets.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  RequestNotifier _auth;
  TextEditingController _firstName = TextEditingController();
  TextEditingController _lastName = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();

  void _onSingInClicked() {
    Navigator.pop(context);
  }

  void _onSingUpClicked() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      _auth
          .register(
              "${_firstName.text.toString().trim()} ${_lastName.text.toString().trim()}",
              _email.text.toString().trim(),
              _password.text.toString().trim())
          .then((response) {
        setState(() {
          _loading = false;
        });
        if (response["status"] as bool) {
          preferences.putBool(SharedPreference.IS_REGISTERED, true);
          UserItem userItem = UserItem.fromJson(response["data"]);
          Provider.of<UserProvider>(context, listen: false)
              .setUserItem(userItem);
          preferences.saveUser(userItem);
          print("Logged in with: ${userItem.username}");
          Navigator.pushReplacementNamed(context, Routes.dashboardRoute);
        } else {
          print(response["message"]);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response["message"])));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<RequestNotifier>(context);

    return Stack(children: [
      Container(
        height: mediaQueryH(context),
        color: Color(0xFFFEF8F6),
      ),
      Positioned(
        width: mediaQueryW(context),
        child: Image.asset(
          "assets/images/background.png",
          fit: BoxFit.fill,
          height: mediaQueryH(context) * 0.25,
        ),
        bottom: 0,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.symmetric(
                  vertical: mediaQueryH(context) * 0.04, horizontal: 20),
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Column(children: [
                  "assets/images/logo.png".appLogo(
                      w: mediaQueryW(context) * 0.2,
                      h: mediaQueryH(context) * 0.15),
                  Text(
                    "Sign up",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  (mediaQueryH(context) * 0.04).addHSpace(),
                  CustomTextField(
                    controller: _firstName,
                    text: "First Name",
                    imageName: "assets/images/user.png",
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please enter first name";
                      }
                      return null;
                    },
                  ),
                  10.addHSpace(),
                  CustomTextField(
                    controller: _lastName,
                    text: "Last Name",
                    imageName: "assets/images/user.png",
                  ),
                  10.addHSpace(),
                  CustomTextField(
                    controller: _email,
                    text: "Email Address",
                    imageName: "assets/images/email.png",
                    inputType: TextInputType.emailAddress,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please enter email.";
                      } else {
                        if (!value.isValidEmail()) {
                          return "Please enter valid email.";
                        }
                      }
                      return null;
                    },
                  ),
                  10.addHSpace(),
                  PasswordTextField(
                    controller: _password,
                    text: "Password",
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please enter password.";
                      } else {
                        if (value.length < 7) {
                          return "Please enter at least 7 character password.";
                        }
                      }
                      return null;
                    },
                  ),
                  10.addHSpace(),
                  PasswordTextField(
                    controller: _confirmPassword,
                    text: "Confirm Password",
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "Please enter confirm password.";
                      } else {
                        if (value != _password.text.toString().trim()) {
                          return "Confirm password doesn't match.";
                        }
                      }
                      return null;
                    },
                  ),
                  (mediaQueryH(context) * 0.03).addHSpace(),
                  GradientRaisedButton("Sign up", _onSingUpClicked),
                  (mediaQueryH(context) * 0.03).addHSpace(),
                  "- OR -".buttonText(isBold: false, color: Color(0xFF3E454F)),
                  (mediaQueryH(context) * 0.02).addHSpace(),
                  SignUpButton(
                      text: "Already have an Account ?",
                      subText: " Sign in",
                      onButtonClicked: _onSingInClicked)
                ]),
              ),
            ),
          ),
        ),
      ),
      Visibility(
        child: Container(
          child: Center(
            child: CircularProgressIndicator.adaptive(strokeWidth: 5),
          ),
          color: Colors.white24,
        ),
        visible: _loading,
      )
    ]);
  }
}
