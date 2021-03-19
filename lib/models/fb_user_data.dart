import 'dart:convert';

FacebookUserData googleUserItemFromJson(String str) => FacebookUserData.fromJson(json.decode(str));

String googleUserItemToJson(FacebookUserData data) => json.encode(data.toJson());

class FacebookUserData {
  FacebookUserData({
    this.name,
    this.email,
    this.picture,
    this.id,
  });

  String name;
  String email;
  Picture picture;
  String id;

  factory FacebookUserData.fromJson(Map<String, dynamic> json) => FacebookUserData(
    name: json["name"],
    email: json["email"],
    // picture: Picture.fromJson(json["picture"]),
    id: json["id"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "picture": picture.toJson(),
    "id": id.toString(),
  };
}

class Picture {
  Picture({
    this.data,
  });

  Data data;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Data {
  Data({
    this.height,
    this.isSilhouette,
    this.url,
    this.width,
  });

  int height;
  bool isSilhouette;
  String url;
  int width;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    height: json["height"],
    isSilhouette: json["is_silhouette"],
    url: json["url"],
    width: json["width"],
  );

  Map<String, dynamic> toJson() => {
    "height": height,
    "is_silhouette": isSilhouette,
    "url": url,
    "width": width,
  };
}
