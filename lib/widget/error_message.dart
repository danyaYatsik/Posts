import 'package:flutter/material.dart';
import 'package:posts/util/properties.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final Function method;

  const ErrorMessage({Key key, @required this.message, @required this.method}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text(message),
          RaisedButton(
            child: Text(TRY_AGAIN),
            onPressed: method,
          ),
        ],
      ),
    );
  }
}
