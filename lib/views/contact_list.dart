import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/contact_list/bloc.dart';
import 'package:flutter_contact/bloc/contact_list/contact_list_bloc.dart';
import 'package:flutter_contact/database/contact_repository.dart';
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
                value: userFormBloc..add(_ContactFormBloc.GetContact()),
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

          if (state is ContactsLoadSuccess) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.contacts.length,
              itemBuilder: (BuildContext context, int index) {
                final contact = state.contacts[index];

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
                              BlocProvider<
                                      _ContactFormBloc.ContactFormBloc>.value(
                                  value: userFormBloc
                                    ..add(_ContactFormBloc.GetContact(
                                        contact: contact))),
                              BlocProvider<ContactsListBloc>.value(
                                  value: contactsListBloc),
                            ],
                            child: ContactDetail(),
                          );
                        },
                      ),
                    );
                  },
                  onFavouriteChanged: () {
                    BlocProvider.of<ContactsListBloc>(context).add(
                      ContactUpdated(
                          contact.copyWith(isFavorite: contact.isFavorite)),
                    );
                  },
                  onDelete: () {
                    BlocProvider.of<ContactsListBloc>(context)
                        .add(ContactDeleted(contact));
                  },
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'There is an error, fix it:',
                  ),
                  Text(
                    '',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addContact,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
