import 'package:flutter/material.dart';
import 'package:flutter_contact/bloc/contact_list/bloc.dart';

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
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Expanded(
                  child: Text(
                    'Contacts',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                title: Text('Home page'),
                onTap: () {
                  widget.contactsListBloc.add(ContactListGet());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Favourite Contact'),
                onTap: () {
                  widget.contactsListBloc.add(ContactLoadFavourites());
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
