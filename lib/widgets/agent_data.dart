import 'package:flutter/material.dart';

import '../data/request_constants.dart';
import '../extras/extensions.dart';
import '../models/agent_item.dart';

class AgentData extends StatelessWidget {
  final List<dynamic> items;

  AgentData(this.items);

  @override
  Widget build(BuildContext context) {
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
                            icon:
                                Image.asset(arrowImage, width: 13, height: 13),
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
  }
}
