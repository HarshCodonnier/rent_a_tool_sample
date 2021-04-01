import 'package:flutter/material.dart';

import '../extras/extras.dart';
import '../models/agent_item.dart';
import '../widgets/widgets.dart';

class AgentData extends StatelessWidget {
  final List<dynamic> items;
  final bool isList;
  final bool isVertical;

  AgentData(this.items, this.isList, this.isVertical);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: items.length > 0
          ? isList
              ? Container(
                  height: mediaQueryH(context) * 0.14,
                  child: ListView.builder(
                    itemCount: items.length,
                    scrollDirection:
                        isVertical ? Axis.vertical : Axis.horizontal,
                    itemBuilder: (context, index) => Container(
                        padding: const EdgeInsets.fromLTRB(10, 9, 10, 0),
                        child: AgentListViewItem(
                            item: AgentItem.fromJson(items[index]))),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) =>
                      AgentGridViewItem(item: AgentItem.fromJson(items[index])),
                )
          : Center(
              child: Text("No data available."),
            ),
    );
  }
}
