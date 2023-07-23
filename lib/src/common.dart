import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

var logger = Logger();

var SourceIP = "3.104.122.162:8085";

void showSnackBar(BuildContext context, String text)
{
  final snackBar = SnackBar(
    content: Text(text),
    duration: const Duration(seconds: 3)
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showPopUpMessage(BuildContext context, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Text(msg),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}