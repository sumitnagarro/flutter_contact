import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Helper {
  Future<String> getImage(BuildContext ctx) async {
    final picker = ImagePicker();
    String path;
    PickedFile imagePicked;
    ImageSource source;
    final _ = await showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pick Image"),
            content: new Text("Take/Browse photo of person"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Camera"),
                onPressed: () {
                  source = ImageSource.camera;
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Gallary"),
                onPressed: () {
                  source = ImageSource.gallery;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    if (source == null) return null;
    imagePicked = await picker.getImage(source: source);

    path = imagePicked?.path;
    return path;
  }
}
