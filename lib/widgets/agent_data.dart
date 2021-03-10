import 'package:flutter/material.dart';

import '../data/request_constants.dart';
import '../data/request_notifier.dart';
import '../extras/extensions.dart';
import '../models/agent_item.dart';

class AgentData extends StatelessWidget {
  final RequestNotifier auth;
  final String searchedText;

  AgentData(this.auth, this.searchedText);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: auth.getAgentList(1, 50, searchedText),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["status"]) {
            var items = snapshot.data["data"] as List<dynamic>;
            return Container(
              color: Colors.white,
              child: ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  AgentItem item = AgentItem.fromJson(items[index]);
                  return Container(
                    padding: EdgeInsets.fromLTRB(10, 9, 10, 0),
                    child: Card(
                      elevation: 4,
                      shadowColor: cardShadowColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: item.agentProfile == null ||
                                          item.agentProfile.isEmpty
                                      ? Image.asset(
                                          placeHolderImage,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        )
                                      : FadeInImage.assetNetwork(
                                          placeholder: placeHolderImage,
                                          image:
                                              "${AppUrls.IMAGE_BASE_URL}${item.agentProfile}",
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                10.0.addWSpace(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    item.agentName.rowTitleText(),
                                    "${item.totalContainer} Container"
                                        .rowSubTitleText(),
                                    10.0.addHSpace(),
                                    Container(
                                      width: constraints.maxWidth * 0.68,
                                      child: item.containerName.isEmpty
                                          ? "--".rowDetailText()
                                          : item.containerName.rowDetailText(),
                                    ),
                                  ],
                                ),
                                IconButton(
                                    icon: Image.asset(arrowImage,
                                        width: 13, height: 13),
                                    onPressed: () {}),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else {
            return Center(
              child: Container(
                child: Text(snapshot.data["message"] as String),
              ),
            );
          }
        } else if (snapshot.hasError) {
          return Container(
            child: Text("Something wrong"),
          );
        } else {
          return Container(
            // height: constraints.maxHeight * 0.91,
            // height: MediaQuery.of(context).size.height * 0.801,
            child: Center(
              child: CircularProgressIndicator.adaptive(strokeWidth: 5),
            ),
            color: Colors.white24,
          );
        }
      },
    );
  }
}
