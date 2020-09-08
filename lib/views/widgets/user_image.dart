import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contact/models/contact.dart';

class UserImage extends StatelessWidget {
  const UserImage({Key key, @required this.contact, this.radius})
      : super(key: key);
  final double radius;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.grey[300],
      radius: radius,
      backgroundImage: contact?.image != 'fromasset'
          ? Image.file(File(contact?.image)).image
          : AssetImage('assest/images/default.png'),
    );
  }
}
