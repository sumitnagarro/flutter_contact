import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contact/models/contact.dart';
import 'package:flutter_contact/views/widgets/user_image.dart';

class ContactItem extends StatelessWidget {
  final DismissDirectionCallback onDismissed;
  final GestureTapCallback onTap;
  final GestureTapCallback onDelete;
  final GestureTapCallback onFavouriteChanged;
  final Contact contact;

  ContactItem({
    @required this.onDismissed,
    @required this.onTap,
    @required this.onDelete,
    @required this.onFavouriteChanged,
    @required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: UserImage(
          contact: contact,
          radius: 25,
        ),
        title: Text(
          contact.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          contact.mobileNumber,
          maxLines: 1,
          textAlign: TextAlign.start,
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(
            Icons.favorite,
            color: contact.isFavorite != 1 ? Colors.grey : Colors.orange[300],
          ),
          onPressed: onFavouriteChanged,
        ),
      ),
    );
  }
}
