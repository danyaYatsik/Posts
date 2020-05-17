import 'dart:convert';

import 'package:posts/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:posts/util/properties.dart';

class PostsApi {
  final String _url = '$BASE_URL/posts';

  Future<List<Post>> loadPosts() async {
    var response = await http.get(_url);
    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map((value) => Post(
                userId: value['userId'],
                id: value['id'],
                title: value['title'],
                body: value['body'],
              ))
          .toList()
          .cast<Post>();
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
