import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';

import '../data/request_notifier.dart';
import '../extras/extensions.dart';
import '../extras/shared_pref.dart';
import '../models/user_item.dart';
import '../screens/login_page.dart';
import '../widgets/agent_data.dart';
import '../widgets/search_text_field.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  RequestNotifier _auth;

  TextEditingController _searchController = TextEditingController();
  String _searchedText = "";
  Future<Map<String, dynamic>> _futureAgents;
  bool _showLoading = true;
  bool _isKeyboardOpen = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        _isKeyboardOpen = visible;
      },
    );
  }

  void _onLogoutClicked(BuildContext context) {
    preferences.clearUserItem();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage(), maintainState: false));
  }

  void _onSearchSubmit(String value) {
    print(value);
    setState(() {
      _searchedText = value;
    });
  }

  void _onSearchChanged(String value) {
    print(value);

    _searchedText = value;
    if (_searchedText.length > 2) {
      setState(() {
        _showLoading = true;
        _futureAgents = _auth.getAgentList(1, 50, _searchedText);
      });
      return;
    }
    if (_searchedText.isEmpty) {
      setState(() {
        _showLoading = true;
        _futureAgents = _auth.getAgentList(1, 50, _searchedText);
      });
      return;
    }
  }

  Widget _getAgentData() {
    return FutureBuilder(
      future: _futureAgents,
      builder: (context, snapshot) {
        /*if (snapshot.hasData) {
          if (snapshot.data["status"]) {
            print("working fine");
            var items = snapshot.data["data"] as List<dynamic>;
            return AgentData(items);
          } else {
            print("error in data");
            return errorWidget(snapshot.data["message"]);
          }
        } else if (snapshot.hasError) {
          print("error in request");
          return errorWidget();
        }*/
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (_showLoading && _isKeyboardOpen) {
            _showLoading = false;
            return loaderWidget(context);
          }
        }
        if (snapshot.hasData) {
          _showLoading = false;
          if (snapshot.data["status"]) {
            var items = snapshot.data["data"] as List<dynamic>;
            return AgentData(items);
          } else {
            return errorWidget(snapshot.data["message"]);
          }
        } else if (snapshot.hasError) {
          _showLoading = false;
          return errorWidget();
        } else {
          return loaderWidget(context);
        }
        // return loaderWidget(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    UserItem userItem = Provider.of<UserProvider>(context).userItem;
    _auth = Provider.of<RequestNotifier>(context);
    _futureAgents = _auth.getAgentList(
        1, 50, _searchedText.length > 2 ? _searchedText : "");
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
            // onPressed: () => _onSearchChanged("jos"),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: mediaQueryH(context) * 0.07,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            color: Color(0xFF5DDE5D),
            child: SearchTextField(
              _searchController,
              _onSearchSubmit,
              _onSearchChanged,
            ),
          ),
          Expanded(child: _getAgentData()),
        ],
      ),
    );
  }
}
