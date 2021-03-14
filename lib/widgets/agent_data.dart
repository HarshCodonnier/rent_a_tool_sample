import 'package:flutter/material.dart';
import 'package:rent_a_tool_sample/widgets/image_widget.dart';

import '../extras/extensions.dart';
import '../models/agent_item.dart';

class AgentData extends StatelessWidget {
  final List<dynamic> items;

  AgentData(this.items);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: items.length > 0
          ? ListView.builder(
              addAutomaticKeepAlives: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                AgentItem item = AgentItem.fromJson(items[index]);
                return Container(
                  padding: const EdgeInsets.fromLTRB(10, 9, 10, 0),
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
                                    10.0.addHSpace(),
                                    Container(
                                      child: item.containerName.isEmpty
                                          ? "--".rowDetailText()
                                          : item.containerName.rowDetailText(),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                  icon: Image.asset(arrowImage),
                                  onPressed: () {}),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text("No data available."),
            ),
    );
  }
}
