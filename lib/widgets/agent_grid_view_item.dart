import 'package:flutter/material.dart';

import '../extras/extras.dart';
import '../models/agent_item.dart';
import '../screens/user_distance.dart';
import '../widgets/widgets.dart';

class AgentGridViewItem extends StatelessWidget {
  const AgentGridViewItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  final AgentItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 0),
      child: Card(
        elevation: 4,
        shadowColor: cardShadowColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 5, 0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: ImageWidget(
                          imageUrl: item.agentProfile,
                          width: 50,
                          height: 50,
                          placeHolderImage: placeHolderImage,
                        ),
                      ),
                      10.0.addWSpace(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            item.agentName.rowTitleText(),
                            "${item.totalContainer} Container"
                                .rowSubTitleText(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  5.addHSpace(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: item.containerName.isEmpty
                              ? "--".rowDetailText()
                              : item.containerName.rowDetailText(2),
                        ),
                      ),
                      IconButton(
                          icon: Image.asset(arrowImage),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDistance(),
                              ),
                            );
                          }),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
