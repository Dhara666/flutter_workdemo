// To parse this JSON data, do
//
//     final blocResponse = blocResponseFromJson(jsonString);

import 'dart:convert';

List<BlocResponse> blocResponseFromJson(String str) => List<BlocResponse>.from(
    json.decode(str).map((x) => BlocResponse.fromJson(x)));

String blocResponseToJson(List<BlocResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BlocResponse {
  BlocResponse({
    this.id,
    this.author,
    this.width,
    this.height,
    this.url,
    this.downloadUrl,
  });

  String id;
  String author;
  int width;
  int height;
  String url;
  String downloadUrl;

  factory BlocResponse.fromJson(Map<String, dynamic> json) => BlocResponse(
        id: json["id"],
        author: json["author"],
        width: json["width"],
        height: json["height"],
        url: json["url"],
        downloadUrl: json["download_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "author": author,
        "width": width,
        "height": height,
        "url": url,
        "download_url": downloadUrl,
      };
}
