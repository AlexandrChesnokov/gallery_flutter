import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:photos_from_api/model/photo.dart';

class Api {
  Future<List<Photo>> fetchPhotos() async {
    final response = await http.get(Uri.parse(
        "https://api.unsplash.com/photos?page=1&per_page=15&client_id=896d4f52c589547b2134bd75ed48742db637fa51810b49b607e37e46ab2c0043"));
    List<Photo> photos = [];

    List list = jsonDecode(response.body);

    for (Map<String, dynamic> e in list) {
      photos.add(Photo.fromJson(e));
    }

    if (response.statusCode == 200) {
      return photos;
    } else {
      throw Exception('Failed to load album');
    }
  }
}
