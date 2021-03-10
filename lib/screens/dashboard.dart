import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_a_tool_sample/widgets/agent_data.dart';
import 'package:rent_a_tool_sample/widgets/search_text_field.dart';

import '../data/request_notifier.dart';
import '../extras/shared_pref.dart';
import '../models/user_item.dart';
import '../screens/login_page.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  RequestNotifier _auth;

  TextEditingController _searchController = TextEditingController();
  String _searchedText = "";

  void _onLogoutClicked(BuildContext context) {
    preferences.clearUserItem();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), maintainState: false));
  }

  void _onSearchSubmit(String value) async {
    print(value);
    setState(() {
      _searchedText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserItem userItem = Provider.of<UserProvider>(context).userItem;
    _auth = Provider.of<RequestNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Hello, ${preferences.getUserItem().username}"),
        backgroundColor: Color(0xFF5DDE5D),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () => _onLogoutClicked(context),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.07,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            color: Color(0xFF5DDE5D),
            child: SearchTextField(_searchController, _onSearchSubmit),
          ),
          Expanded(
            // height: constraints.maxHeight,
            // height: MediaQuery.of(context).size.height * 0.801,
            child: AgentData(_auth, _searchedText),
          ),
        ],
      ),
    );
  }
}
