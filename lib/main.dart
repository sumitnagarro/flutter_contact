import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/bloc_observer.dart';
import 'package:flutter_contact/bloc/contact_form/bloc.dart';

import 'database/contact_repository.dart';
import "views/contact_list.dart";

import 'bloc/contact_list/bloc.dart';

void main() {
  Bloc.observer = ContactAppBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<ContactsListBloc>(
            create: (context) => ContactsListBloc(
                ContactRepository()), //..add(ContactListGet()),
          ),
          BlocProvider<ContactFormBloc>(
            create: (context) => ContactFormBloc(ContactRepository()),
          ),
        ],
        child: MyHomePage(title: 'Contact'),
      ),
    );
  }
}
