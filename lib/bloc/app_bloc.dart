import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:posts/api/comments_api.dart';
import 'package:posts/api/posts_api.dart';
import 'package:posts/bloc/bloc_base.dart';
import 'package:posts/model/comment.dart';
import 'package:posts/model/post.dart';
import 'package:posts/page/comments_page.dart';

class AppBloc extends BlocBase {
  List<Post> _posts;
  final PostsApi _postsApi = PostsApi();
  final CommentsApi _commentsApi = CommentsApi();

  final StreamController<AppState> _counterController =
      StreamController<AppState>.broadcast();
  StreamSink<AppState> get _sink => _counterController.sink;
  Stream<AppState> get stream => _counterController.stream;

  void loadPosts() async {
    try {
      if (_posts == null) {
        _posts = await _postsApi.loadPosts();
      }
      _sink.add(PostsPresentState(_posts));
    } catch (e) {
      _sink.add(ErrorState(e.toString(), loadPosts));
    }
  }

  void loadComments(Post post) async {
    try {
      var comments = await _commentsApi.loadComments(post.id);
      _sink.add(CommentsPresentState(post, comments));
    } catch (e) {
      _sink.add(ErrorState(e.toString(), loadComments));
    }
  }

  void openComments(BuildContext context, post) {
    Navigator.pushNamed(context, CommentsPage.ROUTE, arguments: post);
  }

  @override
  void dispose() {
    _counterController.close();
    _sink.close();
  }
}

class AppState {}

class PostsPresentState extends AppState {
  final List<Post> posts;

  PostsPresentState(this.posts);
}

class LoadingState extends AppState {}

class CommentsPresentState extends AppState {
  final Post post;
  final List<Comment> comments;

  CommentsPresentState(this.post, this.comments);
}

class ErrorState extends AppState {
  final String message;
  final Function method;

  ErrorState(this.message, this.method);
}
