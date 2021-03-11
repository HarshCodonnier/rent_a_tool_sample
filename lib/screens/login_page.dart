import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/request_notifier.dart';
import '../extras/extensions.dart';
import '../extras/shared_pref.dart';
import '../models/user_item.dart';
import '../screens/registration_page.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_raised_button.dart';
import '../widgets/password_text_field.dart';
import '../widgets/sign_up_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String _email = "";
  String _password = "";
  RequestNotifier _auth;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  String _emailErrorMessage = "";
  String _passwordErrorMessage = "";
  bool _isEmailError = false;
  bool _isPasswordError = false;

  void _onLoginClicked() async {
    /*if (_emailController.text.toString().isEmpty) {
      _emailErrorMessage = "Please enter email field.";
      setState(() {
        _isEmailError = true;
      });
      return;
    }
    if (_passwordController.text.toString().isEmpty) {
      _passwordErrorMessage = "Please enter password field.";
      setState(() {
        _isPasswordError = true;
      });
      return;
    }
    if (_emailController.text.toString().isNotEmpty) {
      if (!_emailController.text.toString().isValidEmail()) {
        _emailErrorMessage = "Please enter valid email.";
        setState(() {
          _isEmailError = true;
        });
        return;
      }
      setState(() {
        _isEmailError = false;
      });
    }
    if (_passwordController.text.toString().isNotEmpty) {
      if (_passwordController.text.toString().length > 1 &&
          _passwordController.text.toString().length < 7) {
        _passwordErrorMessage = "Please enter at lease 7 character password.";
        setState(() {
          _isPasswordError = true;
        });
        return;
      }
      setState(() {
        _isPasswordError = false;
      });
    }
    setState(() {
      _isEmailError = false;
      _isPasswordError = false;
      _loading = true;
    });*/
    // await EasyLoading.show();
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      _auth
          .login(_emailController.text.toString().trim(),
              _passwordController.text.toString().trim())
          .then((response) {
        setState(() {
          _loading = false;
        });
        // await EasyLoading.dismiss(animation: true);
        if (response["status"]) {
          UserItem userItem = UserItem.fromJson(response["data"]);
          preferences.putBool(SharedPreference.IS_LOGGED_IN, true);
          preferences.putString(
              SharedPreference.AUTH_TOKEN, userItem.authToken);
          preferences.saveUser(userItem);
          print(response["message"]);
          Provider.of<UserProvider>(context, listen: false)
              .setUserItem(userItem);
          Navigator.pushReplacementNamed(context, Routes.dashboardRoute);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(response["message"]),
          ));
        }
      });
    }
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
    _auth = Provider.of<RequestNotifier>(context);

    return Scaffold(
      body: Stack(children: [
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
        SingleChildScrollView(
          child: SafeArea(
            child: Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.symmetric(
                  vertical: mediaQueryH(context) * 0.01, horizontal: 20),
              child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: _formKey,
                child: Column(
                  children: [
                    "assets/images/logo.png".appLogo(
                        w: mediaQueryW(context) * 0.2,
                        h: mediaQueryH(context) * 0.2),
                    (mediaQueryH(context) * 0.01).addHSpace(),
                    Text(
                      "Sign in",
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    (mediaQueryH(context) * 0.06).addHSpace(),
                    CustomTextField(
                      controller: _emailController,
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
                      onSaved: (String value) {
                        _email = value;
                      },
                    ),
                    Visibility(
                      child: _emailErrorMessage.errorText(),
                      visible: _isEmailError,
                    ),
                    5.addHSpace(),
                    PasswordTextField(
                      controller: _passwordController,
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
                      onSaved: (String value) {
                        _password = value;
                      },
                    ),
                    Visibility(
                      child: _passwordErrorMessage.errorText(),
                      visible: _isPasswordError,
                    ),
                    (mediaQueryH(context) * 0.04).addHSpace(),
                    GradientRaisedButton("Sign in", _onLoginClicked),
                    // CustomTextButton(
                    //     "Forgot Password?", _onForgotPasswordClicked),
                    (mediaQueryH(context) * 0.12).addHSpace(),
                    "- OR -"
                        .buttonText(isBold: false, color: Color(0xFF3E454F)),
                    (mediaQueryH(context) * 0.02).addHSpace(),
                    SignUpButton(
                        text: "Don't have an Account ?",
                        subText: " Sign up",
                        onButtonClicked: _onSignUpClicked)
                  ],
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
      ]),
    );
  }
}
