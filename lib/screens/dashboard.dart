import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_tool_sample/extras/shared_pref.dart';
import 'package:rent_a_tool_sample/screens/login_page.dart';

import '../extras/extensions.dart';
import '../models/user_item.dart';

class Dashboard extends StatelessWidget {
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
            ElevatedButton(
                child: Text("Don't have an Account ?"),
                onPressed: () {
                  preferences.clearUserItem();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(),
                          maintainState: false));
                })
          ],
        ),
      ),
    );
  }
}
