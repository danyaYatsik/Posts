import 'package:flutter/material.dart';
import 'package:posts/bloc/bloc_provider.dart';
import 'package:posts/bloc/app_bloc.dart';
import 'package:posts/util/properties.dart';
import 'package:posts/widget/error_message.dart';

class PostsPage extends StatefulWidget {
  static const ROUTE = '/posts';

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  AppBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AppBloc>(context);
    _bloc.loadPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: _bloc.stream,
          initialData: LoadingState(),
          builder: (context, snapshot) {
            AppState data = snapshot.data;
            switch (data.runtimeType) {
              case LoadingState:
                return _indicator();
                break;
              case PostsPresentState:
                return _posts(data);
                break;
              case ErrorState:
                return _error(data);
                break;
              default:
                return _unknownState();
            }
          },
        ),
      ),
    );
  }

  _posts(PostsPresentState data) => ListView(
        children: data.posts
            .map(
              (post) => ListTile(
                title: Text(post.title),
                subtitle: Text(post.body),
                onTap: () => _bloc.openComments(context, post),
              ),
            )
            .toList(),
      );

  _indicator() => Center(
        child: CircularProgressIndicator(),
      );

  _error(ErrorState data) => ErrorMessage(
        message: data.message,
        method: data.method,
      );

  _unknownState() => Center(
        child: Text(UNKNOWN_STATE_MESSAGE),
      );
}
