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
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onTap,
                child: Row(
                  children: [
                    Hero(
                      tag: '${contact.contactId}__heroTag',
                      child: UserImage(
                        contact: contact,
                        radius: 25,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contact.name,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          Text(
                            contact.mobileNumber,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onPressed: onDelete,
            ),
            IconButton(
              icon: Icon(
                Icons.favorite,
                color:
                    contact.isFavorite == 1 ? Colors.grey : Colors.orange[300],
              ),
              onPressed: onFavouriteChanged,
            ),
          ],
        ),
      ),
    );
  }
}
