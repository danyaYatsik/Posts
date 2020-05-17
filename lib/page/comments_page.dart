import 'package:flutter/material.dart';
import 'package:posts/bloc/bloc_provider.dart';
import 'package:posts/bloc/app_bloc.dart';
import 'package:posts/model/post.dart';
import 'package:posts/util/properties.dart';
import 'package:posts/widget/error_message.dart';

class CommentsPage extends StatefulWidget {
  static const ROUTE = '/comments';

  @override
  State<StatefulWidget> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  AppBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<AppBloc>(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Post post = ModalRoute.of(context).settings.arguments;
    _bloc.loadComments(post);
    super.didChangeDependencies();
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
                case CommentsPresentState:
                  return _comments(data);
                  break;
                case LoadingState:
                  return _indicator();
                  break;
                case ErrorState:
                  return _error(data);
                  break;
                default:
                  return _unknownState();
              }
            }),
      ),
    );
  }

  _comments(CommentsPresentState data) => Column(
        children: <Widget>[
          ListTile(
            title: Text(data.post.title),
            subtitle: Text(data.post.body),
          ),
          Divider(),
          Flexible(
            child: ListView(
              children: data.comments
                  .map((e) => ListTile(
                        title: Text(e.name),
                        subtitle: Text(e.body),
                      ))
                  .toList(),
            ),
          ),
        ],
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
