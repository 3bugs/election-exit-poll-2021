import 'package:flutter/material.dart';

void showMaterialDialog(BuildContext context, String title, String msg) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(msg, style: Theme.of(context).textTheme.bodyText2),
        actions: [
          // ปุ่ม OK ใน dialog
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              // ปิด dialog
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
