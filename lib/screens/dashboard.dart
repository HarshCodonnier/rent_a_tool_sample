import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/request_constants.dart';
import '../data/request_notifier.dart';
import '../extras/extensions.dart';
import '../extras/shared_pref.dart';
import '../models/agent_item.dart';
import '../models/user_item.dart';
import '../screens/login_page.dart';

class Dashboard extends StatelessWidget {
  RequestNotifier auth;

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
    auth = Provider.of<RequestNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Dashboard"),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              icon: Icon(Icons.power_settings_new),
              onPressed: () {
                preferences.clearUserItem();
                Navigator.pushReplacementNamed(context, Routes.defaultRoute);
              })
        ],
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data["status"]) {
                var items = snapshot.data["data"] as List<dynamic>;
                return ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    AgentItem item = AgentItem.fromJson(items[index]);
                    return Container(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                          "assets/images/placeholder.png",
                                      image:
                                          "${AppUrls.IMAGE_BASE_URL}${item.agentProfile}",
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  10.0.addWSpace(),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      item.agentName.headerText(),
                                      Text("${item.totalContainer} Container"),
                                      10.0.addHSpace(),
                                      Container(
                                        width: constraints.maxWidth * 0.75,
                                        child: Text(
                                          item.containerName.isEmpty
                                              ? "--"
                                              : item.containerName,
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(
                  child: Container(
                    child: Text(snapshot.data["message"] as String),
                  ),
                );
              }
            } else {
              return Container(
                child: Center(
                  child: CircularProgressIndicator.adaptive(strokeWidth: 5),
                ),
                color: Colors.white24,
              );
            }
          } else if (snapshot.hasError) {
            return Container(
              child: Text("Something wrong"),
            );
          } else {
            return Container(
              child: Center(
                child: CircularProgressIndicator.adaptive(strokeWidth: 5),
              ),
              color: Colors.white24,
            );
          }
        },
        future: auth.getAgentList(1, 50, ""),
      ),
    );
  }
}
