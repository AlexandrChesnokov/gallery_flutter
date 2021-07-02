import 'dart:convert';


class Photo {
  String author;
  String name;
  String urlSmall;
  String urlMax;

  Photo(
      {required this.author,
      required this.name,
      required this.urlSmall,
      required this.urlMax});

  factory Photo.fromJson(Map<String, dynamic> json) {
    String apiKey =
        '/?client_id=ab3411e4ac868c2646c0ed488dfd919ef612b04c264f3374c97fff98ed253dc9';
    Map<String, dynamic> userInfo = json['user'];
    Map<String, dynamic> urls = json['urls'];

    return Photo(
        author: userInfo['name'],
        name: json['description'] ?? '',
        urlSmall: urls['small'] + apiKey,
        urlMax: urls['full'] + apiKey);
  }
}
