import 'package:flutter/material.dart';

import '../extras/extensions.dart';
import '../models/agent_item.dart';
import '../screens/user_distance.dart';
import '../widgets/image_widget.dart';

class AgentListViewItem extends StatelessWidget {
  const AgentListViewItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  final AgentItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: cardShadowColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 5, 10),
        child: Row(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                item.agentName.rowTitleText(),
                "${item.totalContainer} Container".rowSubTitleText(),
                10.0.addHSpace(),
                Container(
                  child: item.containerName.isEmpty
                      ? "--".rowDetailText()
                      : item.containerName.rowDetailText(),
                ),
              ],
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
      ),
    );
  }
}
