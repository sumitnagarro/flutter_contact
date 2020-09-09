import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/contact_form/bloc.dart';
import 'package:flutter_contact/bloc/contact_list/bloc.dart';
import 'package:flutter_contact/database/contact_repository.dart';
import 'package:flutter_contact/views/favourite_contacts.dart';

class AppDrawer extends StatefulWidget {
  AppDrawer({Key key, this.contactsListBloc}) : super(key: key);

  final ContactsListBloc contactsListBloc;
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Contacts',
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                title: Text('Home page'),
                onTap: () {
                  widget.contactsListBloc.add(ContactListGet(false));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Favourite Contact'),
                onTap: () async {
                  //widget.contactsListBloc.add(ContactLoadFavourites());
                  //Poping drawer
                  Navigator.pop(context);

                  await Navigator.of(context).push(
                    MaterialPageRoute<FavouriteContacts>(
                      builder: (context) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider<ContactsListBloc>(
                              create: (context) =>
                                  ContactsListBloc(ContactRepository())
                                    ..add(ContactLoadFavourites()),
                            ),
                            BlocProvider<ContactFormBloc>(
                              create: (context) =>
                                  ContactFormBloc(ContactRepository()),
                            ),
                          ],
                          child: FavouriteContacts(),
                        );
                      },
                    ),
                  );
                  widget.contactsListBloc.add(ContactListGet(false));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
