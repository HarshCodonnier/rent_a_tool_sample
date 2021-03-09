import 'dart:convert';

List<AgentItem> agentItemFromJson(String str) =>
    List<AgentItem>.from(json.decode(str).map((x) => AgentItem.fromJson(x)));

String agentItemToJson(List<AgentItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AgentItem {
  AgentItem({
    this.agentId,
    this.agentToken,
    this.agentName,
    this.agentProfile,
    this.totalContainer,
    this.containerName,
  });

  int agentId;
  String agentToken;
  String agentName;
  String agentProfile;
  int totalContainer;
  String containerName;

  factory AgentItem.fromJson(Map<String, dynamic> json) => AgentItem(
        agentId: json["agent_id"],
        agentToken: json["agent_token"],
        agentName: json["agent_name"],
        agentProfile: json["agent_profile"],
        totalContainer: json["total_container"],
        containerName: json["container_name"],
      );

  Map<String, dynamic> toJson() => {
        "agent_id": agentId,
        "agent_token": agentToken,
        "agent_name": agentName,
        "agent_profile": agentProfile,
        "total_container": totalContainer,
        "container_name": containerName,
      };
}
