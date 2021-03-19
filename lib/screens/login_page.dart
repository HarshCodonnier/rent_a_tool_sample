import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_tool_sample/models/fb_user_data.dart';

import '../data/request_notifier.dart';
import '../extras/extras.dart';
import '../models/user_item.dart';
import '../screens/screens.dart';
import '../widgets/widgets.dart';

GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: ['email'],
);

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  RequestNotifier _auth;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  String _emailErrorMessage = "";
  String _passwordErrorMessage = "";
  bool _isEmailError = false;
  bool _isPasswordError = false;
  GoogleSignInAccount _currentUser;

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
          preferences.putString(
              SharedPreference.AUTH_TOKEN, userItem.authToken);
          preferences.saveUser(userItem);
          print(response["message"]);
          Provider.of<UserProvider>(context, listen: false)
              .setUserItem(userItem);
          print("Logged in with: ${userItem.username}");
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
    print("clicked");
  }

  void _onSignUpClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage(),
      ),
    );
  }

  _googleSignIn(GoogleSignInAccount googleSignInAccount) async {
    try {
      assert(googleSignInAccount != null);
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      assert(googleSignInAuthentication != null);

      setState(() {
        _loading = true;
      });
      print("Logged in with Google: ${googleSignInAccount.displayName}");
      print("googleId: ${googleSignInAccount.id}");
      _auth
          .register(googleSignInAccount.displayName, googleSignInAccount.email,
              "1234567", googleSignInAccount.id)
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
          Navigator.pushReplacementNamed(context, Routes.dashboardRoute);
          return;
        } else {
          print(response["message"]);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response["message"])));
        }
      });
    } catch (error) {
      setState(() {
        _loading = false;
      });
      print(error);
    }
  }

  void _facebookSignIn() async {
    try {
      final fbAccessToken = await FacebookAuth.instance.login();
      assert(fbAccessToken != null);
      final userData = await FacebookAuth.instance.getUserData();
      assert(userData != null);
      setState(() {
        _loading = true;
      });
      print(userData);
      FacebookUserData facebookUserData = FacebookUserData.fromJson(userData);
      print("Logged in with Facebook: ${facebookUserData.name}");
      print("fbId: ${facebookUserData.id}");
      _auth
          .register(facebookUserData.name, facebookUserData.email, "1234567",
              facebookUserData.id.toString())
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
          Navigator.pushReplacementNamed(context, Routes.dashboardRoute);
          return;
        } else {
          print(response["message"]);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(response["message"])));
        }
      });
    } on FacebookAuthException catch (e) {
      print(e.message);
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          print("You have a previous login operation in progress");
          break;
        case FacebookAuthErrorCode.CANCELLED:
          print("login CANCELLED");
          break;
        case FacebookAuthErrorCode.FAILED:
          print("login FAILED");
          break;
      }
    } catch (error) {
      setState(() {
        _loading = false;
      });
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();

    googleSignIn.onCurrentUserChanged.listen((googleSignInAccount) {
      _googleSignIn(googleSignInAccount);
    }, onError: (error) {
      print("Google signIn error onCurrentUserChanged: $error");
    });

    if (preferences.getBool(SharedPreference.IS_LOGGED_IN)) {
      googleSignIn
          .signInSilently(suppressErrors: false)
          .then((googleSignInAccount) => _googleSignIn(googleSignInAccount))
          .catchError((error) {
        print("Google signIn error signInSilently: $error");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount user = _currentUser;
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
        body: SafeArea(
          child: SingleChildScrollView(
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
                    ),
                    10.addHSpace(),
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
                    ),
                    Visibility(
                      child: _passwordErrorMessage.errorText(),
                      visible: _isPasswordError,
                    ),
                    (mediaQueryH(context) * 0.04).addHSpace(),
                    GradientRaisedButton("Sign in", _onLoginClicked),
                    CustomTextButton(
                        "Forgot Password?", _onForgotPasswordClicked),
                    (mediaQueryH(context) * 0.08).addHSpace(),
                    "- OR -"
                        .buttonText(isBold: false, color: Color(0xFF3E454F)),
                    (mediaQueryH(context) * 0.02).addHSpace(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialSignInButton(
                          icon: FontAwesomeIcons.google,
                          color: Color(0xFFDB4437),
                          onClick: () => googleSignIn.signIn(),
                        ),
                        15.addWSpace(),
                        SocialSignInButton(
                          icon: FontAwesomeIcons.facebookF,
                          color: Color(0xFF4267B2),
                          onClick: _facebookSignIn,
                        ),
                      ],
                    ),
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
