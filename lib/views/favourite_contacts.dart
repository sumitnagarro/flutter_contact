import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/contact_list/bloc.dart';
import 'package:flutter_contact/bloc/contact_list/contact_list_bloc.dart';
import 'package:flutter_contact/database/contact_repository.dart';
import 'package:flutter_contact/models/contact.dart';
import 'package:flutter_contact/views/widgets/app_drawer.dart';
import 'package:flutter_contact/views/widgets/contact_list.dart';
import 'package:flutter_contact/views/widgets/error_page.dart';
import 'contact_detail.dart';
import 'widgets/contact_item.dart';
import 'package:flutter_contact/bloc/contact_form/bloc.dart'
    as _ContactFormBloc;

class FavouriteContacts extends StatefulWidget {
  FavouriteContacts({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FavouriteContactsState createState() => _FavouriteContactsState();
}

class _FavouriteContactsState extends State<FavouriteContacts> {
  final ContactRepository contactRepository = ContactRepository();
  _ContactFormBloc.ContactFormBloc userFormBloc;
  ContactsListBloc contactsListBloc;
  getsetData() async {
    final contactBloc = context.bloc<ContactsListBloc>();
    contactBloc.add(ContactListGet());
  }

  @override
  void initState() {
    super.initState();
    getsetData();
  }

  void addContact() {
    Navigator.of(context).push(
      MaterialPageRoute<ContactDetail>(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<_ContactFormBloc.ContactFormBloc>.value(
                value: userFormBloc
                  ..add(_ContactFormBloc.GetContact(contact: Contact())),
              ),
              BlocProvider<ContactsListBloc>.value(value: contactsListBloc),
            ],
            child: ContactDetail(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    userFormBloc = BlocProvider.of<_ContactFormBloc.ContactFormBloc>(context);
    contactsListBloc = BlocProvider.of<ContactsListBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                contacts: state.contacts);
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
      drawer: AppDrawer(
        contactsListBloc: contactsListBloc,
      ),
    );
  }
}
