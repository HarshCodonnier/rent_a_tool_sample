import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_tool_sample/extras/shared_pref.dart';
import 'package:rent_a_tool_sample/screens/login_page.dart';

import '../extras/extensions.dart';
import '../models/user_item.dart';
import '../widgets/sign_up_button.dart';

class Dashboard extends StatelessWidget {
  void _onButtonClicked(BuildContext context) {
    preferences.clearUserItem();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), maintainState: false));
  }

  @override
  Widget build(BuildContext context) {
    UserItem userItem = Provider.of<UserProvider>(context).userItem;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(userItem.username),
            10.addHSpace(),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: SignUpButton(
                  text: "",
                  subText: "Logout",
                  onButtonClicked: () {
                    _onButtonClicked(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
