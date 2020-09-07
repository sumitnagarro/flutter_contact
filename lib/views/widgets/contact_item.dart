import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/models/contact.dart';

class ContactItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final ValueChanged<bool> onFavouriteChanged;
  final Contact contact;

  ContactItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onFavouriteChanged,
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    Image img = Image.file(File(contact.image));
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundImage: img.image,
      ),
      title: Hero(
        tag: '${contact.contactId}__heroTag',
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            contact.name,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
      ),
      subtitle: Text(
        contact.mobileNumber.toString(),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
