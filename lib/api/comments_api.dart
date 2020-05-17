import 'dart:convert';

import 'package:posts/model/comment.dart';
import 'package:posts/util/properties.dart';
import 'package:http/http.dart' as http;

class CommentsApi {
  final _url = '$BASE_URL/comments';

  Future<List<Comment>> loadComments(int postId) async {
    var response = await http.get('$_url?postId=$postId');
    if (response.statusCode == 200) {
      return json
          .decode(response.body)
          .map((value) => Comment(
              id: value['id'],
              postId: value['postId'],
              name: value['name'],
              email: value['email'],
              body: value['body']))
          .toList()
          .cast<Comment>();
    } else {
      throw Exception('Failed to load comments');
    }
  }
}
