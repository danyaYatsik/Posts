import 'package:flutter/material.dart';
import 'package:posts/bloc/bloc_provider.dart';
import 'package:posts/bloc/app_bloc.dart';
import 'package:posts/page/comments_page.dart';
import 'package:posts/page/posts_page.dart';
import 'package:posts/util/properties.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: AppBloc(),
      child: MaterialApp(
        initialRoute: PostsPage.ROUTE,
        routes: {
          PostsPage.ROUTE: (BuildContext context) => PostsPage(),
          CommentsPage.ROUTE: (BuildContext context) => CommentsPage()
        },
        title: APP_NAME,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
      ),
    );
  }
}
