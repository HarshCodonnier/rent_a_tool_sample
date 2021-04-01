import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/data.dart';
import '../extras/extras.dart';
import '../models/user_item.dart';
import '../screens/screens.dart';
import '../widgets/widgets.dart';

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
  String _profileImage = "";
  static const LIST_TO_GRID = "List to Grid";
  static const GRID_TO_LIST = "Grid to List";
  static const HORIZONTAL = "Horizontal";
  static const VERTICAL = "Vertical";

  static Map<int, String> _choicesMap = {
    0: LIST_TO_GRID,
    1: HORIZONTAL,
    2: "Logout"
  };

  bool _isList = true;
  bool _isVertical = true;

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

    if (_searchedText != value && value.length > 2) {
      _searchedText = value;
      setState(() {
        _showLoading = true;
        _futureAgents = _auth.getAgentList(1, 50, _searchedText);
      });
      return;
    }
    if (value.isEmpty) {
      _searchedText = value;
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          if (_showLoading) {
            _showLoading = false;
            return loaderWidget(context);
          }
        }
        if (snapshot.hasData) {
          _showLoading = false;
          if (snapshot.data["status"]) {
            var items = snapshot.data["data"] as List<dynamic>;
            return AgentData(items, _isList, _isVertical);
          } else {
            return errorWidget(snapshot.data["message"]);
          }
        } else if (snapshot.hasError) {
          _showLoading = false;
          return errorWidget();
        } else {
          return loaderWidget(context);
        }
      },
    );
  }

  void _onMenuItemSelected(int choice) {
    setState(() {
      switch (choice) {
        case 0:
          _choicesMap[choice] = _isList ? GRID_TO_LIST : LIST_TO_GRID;
          _isList = !_isList;
          if(!_isList)
            _isVertical = true;
          break;
        case 1:
          _choicesMap[choice] = _isVertical ? VERTICAL : HORIZONTAL;
          _isVertical = !_isVertical;
          if(!_isList)
            _isVertical = true;
          break;
        case 2:
          _onLogoutClicked(context);
          break;
      }
    });
  }

  SnackBar showSnackBar(String selection) {
    return SnackBar(
      content: Text('Selected: $selection'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _profileImage = preferences.getString(SharedPreference.PROFILE_IMAGE);
  }

  @override
  Widget build(BuildContext context) {
    // UserItem userItem = Provider.of<UserProvider>(context).userItem;
    UserItem userItem = preferences.getUserItem();
    _auth = Provider.of<RequestNotifier>(context);
    _futureAgents = _auth.getAgentList(
        1, 50, _searchedText.length > 2 ? _searchedText : "");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Hello, ${userItem.username}"),
        backgroundColor: Color(0xFF5DDE5D),
        actions: [
          IconButton(
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: ImageWidget(
                imageUrl: _profileImage,
                width: appbarImageSize,
                height: appbarImageSize,
                placeHolderImage: placeHolderImage,
                isUserProfile: true,
              ),
            ),
            onPressed: () => Navigator.pushNamed(
                context, Routes.editUserProfile,
                arguments: userItem),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            padding: EdgeInsets.zero,
            onSelected: _onMenuItemSelected,
            itemBuilder: (context) {
              return _choicesMap.keys
                  .map((key) => PopupMenuItem(
                        value: key,
                        child: Text(_choicesMap[key]),
                      ))
                  .toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            color: Color(0xFF5DDE5D),
            child: SearchTextField(
              _searchController,
              _onSearchSubmit,
              _onSearchChanged,
            ),
          ),
          _isVertical
              ? Expanded(child: _getAgentData())
              : _getAgentData(),
        ],
      ),
    );
  }
}
