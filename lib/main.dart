import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_drive/google_drive.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final googleDrive = GoogleDrive();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: FlatButton(
          child: Text("Upload"),
          onPressed: () async {
            var file = await FilePicker.getFile();
            googleDrive.upload(file);
          },
        ),
      ),
    ));
  }
}
