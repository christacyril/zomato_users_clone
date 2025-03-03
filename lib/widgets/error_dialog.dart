import 'package:flutter/material.dart';
import 'package:zomato_users/global/global.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;

  ErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Text(message!),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Text("OK",
                style: TextStyle(
                  color: Colors.white,
                )),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: zomatocolor,
          ),
        )
      ],
    );
  }
}
