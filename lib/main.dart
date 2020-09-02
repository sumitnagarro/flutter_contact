import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/bloc_observer.dart';

import 'database/contact_repository.dart';
import 'models/Contact.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => ContactsListBloc(ContactRepository()),
        child: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final ContactRepository contactRepository = ContactRepository();

  getsetData() async {
    final weatherBloc = context.bloc<ContactsListBloc>();
    weatherBloc.add(ContactListGet());
    // var fido = Contact(
    //     contactId: 1,
    //     name: 'Fido1',
    //     image: 'hahahahaha1',
    //     isFavorite: 1,
    //     mobileNumber: 9998989898,
    //     blocked: 0,
    //     landLine: 886757576676);

    // // Insert a Contact into the database.
    // await contactRepository.insertContact(fido);

    // // Print the list of Contacts (only Fido for now).
    // print(await contactRepository.contacts());
  }

  @override
  void initState() {
    super.initState();
    getsetData();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  return Container(
                    height: 50,
                    child: Center(
                        child: Text('Entry ${state.contacts[index].name}')),
                  );
                });
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
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
