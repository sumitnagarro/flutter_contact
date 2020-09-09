import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/contact_list/bloc.dart';
import 'package:flutter_contact/bloc/contact_list/contact_list_bloc.dart';
import 'package:flutter_contact/views/widgets/contact_list.dart';
import 'package:flutter_contact/views/widgets/error_page.dart';
import 'package:flutter_contact/bloc/contact_form/bloc.dart'
    as _ContactFormBloc;

class FavouriteContacts extends StatefulWidget {
  FavouriteContacts({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FavouriteContactsState createState() => _FavouriteContactsState();
}

class _FavouriteContactsState extends State<FavouriteContacts> {
  _ContactFormBloc.ContactFormBloc userFormBloc;
  ContactsListBloc contactsListBloc;

  @override
  Widget build(BuildContext context) {
    userFormBloc = BlocProvider.of<_ContactFormBloc.ContactFormBloc>(context);
    contactsListBloc = BlocProvider.of<ContactsListBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        contactsListBloc.add(ContactLoadFavourites());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Fav'),
        ),
        body: BlocBuilder<ContactsListBloc, ContactsState>(
          builder: (context, state) {
            if (state is ContactLoadInProgress) {
              return CircularProgressIndicator();
            }
            if (state is ContactsFavouriteLoadSuccess) {
              return ContactList(
                userFormBloc: userFormBloc,
                contactsListBloc: contactsListBloc,
                contacts: state.contacts,
                fromFavourite: true,
              );
            } else {
              return Center(
                child: ErrorPage(
                  buttonText: 'Retry',
                  function: () {
                    contactsListBloc.add(ContactLoadFavourites());
                  },
                  message: 'Something went wrong',
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
