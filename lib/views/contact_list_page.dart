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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ContactRepository contactRepository = ContactRepository();
  _ContactFormBloc.ContactFormBloc userFormBloc;
  ContactsListBloc contactsListBloc;
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
            child: ContactDetail(
              fromFavourite: false,
            ),
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

          if (state is ContactsLoadSuccess) {
            return ContactList(
              userFormBloc: userFormBloc,
              contactsListBloc: contactsListBloc,
              contacts: state.contacts,
              fromFavourite: false,
            );
          } else {
            return Center(
              child: ErrorPage(
                buttonText: 'Retry',
                function: () {
                  contactsListBloc.add(ContactListGet(false));
                },
                message: 'Something went wrong',
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addContact,
        tooltip: 'Add new contact',
        child: Icon(Icons.add),
      ),
      drawer: AppDrawer(
        contactsListBloc: contactsListBloc,
      ),
    );
  }
}
