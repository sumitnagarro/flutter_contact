import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/contact_list/bloc.dart';
import 'package:flutter_contact/bloc/contact_form/bloc.dart'
    as _ContactFormBloc;
import 'package:flutter_contact/models/contact.dart';
import 'package:flutter_contact/views/contact_detail.dart';
import 'package:flutter_contact/views/widgets/contact_item.dart';

class ContactList extends StatelessWidget {
  const ContactList(
      {Key key,
      @required this.userFormBloc,
      @required this.contactsListBloc,
      @required this.contacts,
      this.fromFavourite})
      : super(key: key);

  final _ContactFormBloc.ContactFormBloc userFormBloc;
  final ContactsListBloc contactsListBloc;
  final List<Contact> contacts;
  final bool fromFavourite;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: contacts.length,
      itemBuilder: (BuildContext context, int index) {
        final contact = contacts[index];

        return ContactItem(
          contact: contact,
          onDismissed: (direction) {
            BlocProvider.of<ContactsListBloc>(context)
                .add(ContactDeleted(contact));
          },
          onTap: () async {
            Navigator.of(context).push(
              MaterialPageRoute<ContactDetail>(
                builder: (context) {
                  return MultiBlocProvider(
                    providers: [
                      BlocProvider<_ContactFormBloc.ContactFormBloc>.value(
                          value: userFormBloc
                            ..add(
                                _ContactFormBloc.GetContact(contact: contact))),
                      BlocProvider<ContactsListBloc>.value(
                          value: contactsListBloc),
                    ],
                    child: ContactDetail(
                      fromFavourite: fromFavourite,
                    ),
                  );
                },
              ),
            );
          },
          onFavouriteChanged: () {
            BlocProvider.of<ContactsListBloc>(context).add(
              ContactUpdated(
                  contact.copyWith(
                    isFavorite: contact.isFavorite,
                  ),
                  fromFavourite: fromFavourite),
            );
          },
          onDelete: () {
            BlocProvider.of<ContactsListBloc>(context)
                .add(ContactDeleted(contact));
          },
        );
      },
    );
  }
}
