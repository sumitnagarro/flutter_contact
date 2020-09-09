import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/contact_form/bloc.dart';
import 'package:flutter_contact/bloc/contact_list/bloc.dart';
import 'package:flutter_contact/models/contact.dart';
import 'package:flutter_contact/views/widgets/error_page.dart';
import 'package:flutter_contact/views/widgets/user_image.dart';
import 'package:image_picker/image_picker.dart';

class ContactDetail extends StatefulWidget {
  ContactDetail({Key key, int id}) : super(key: key);

  @override
  _ContactDetailState createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  ContactsListBloc contactListBloc;

  ContactFormBloc contactFormBloc;
  final picker = ImagePicker();
  String path;
  PickedFile imagePicked;
  Future getImage(BuildContext ctx) async {
    ImageSource source;
    await showDialog(
        context: ctx,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Pick Image"),
            content: new Text("Take/Browse photo of person"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Camera"),
                onPressed: () {
                  source = ImageSource.camera;
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text("Gallary"),
                onPressed: () {
                  source = ImageSource.gallery;
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });

    if (source == null) return;
    imagePicked = await picker.getImage(source: source);

    setState(() {
      path = imagePicked.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    contactListBloc = BlocProvider.of<ContactsListBloc>(context);
    contactFormBloc = BlocProvider.of<ContactFormBloc>(context);

    return WillPopScope(
      onWillPop: () async {
        contactFormBloc.add(BackEvent());
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: BlocBuilder<ContactFormBloc, ContactFormState>(
          builder: (context, state) => Text(
              (state.contact?.contactId == null ? 'Add' : 'Edit') + ' Contact'),
        )),
        body: Form(
          key: _formKey,
          child: Container(
            constraints: BoxConstraints.expand(),
            child: SingleChildScrollView(
              child: BlocListener<ContactFormBloc, ContactFormState>(
                listener: (context, state) {
                  contactListBloc.add(ContactListGet());
                },
                child: BlocBuilder<ContactFormBloc, ContactFormState>(
                    builder: (context, state) {
                  if (state is Loaded) {
                    Contact contact = state.contact;
                    path = contact.image;
                    return Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          GestureDetector(
                            child: Center(
                              child: Hero(
                                tag: '${contact.contactId}__heroTag',
                                child: UserImage(
                                  contact: contact,
                                  radius: 100,
                                ),
                              ),
                            ),
                            onTap: () async {
                              await getImage(context);
                              contact.image = path;
                              contactFormBloc
                                  .add(PickContactImage(contact: contact));
                            },
                          ),
                          TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Name:',
                              ),
                              initialValue: contact?.name ?? '',
                              onChanged: (value) {
                                contact?.name = value;
                              },
                              validator: (value) {
                                if (value.length < 1) {
                                  return 'Name cannot be empty';
                                }
                                return null;
                              }),
                          TextFormField(
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Mobile number:',
                              ),
                              initialValue: contact?.mobileNumber ?? '',
                              onChanged: (value) {
                                contact?.mobileNumber = value;
                              },
                              validator: (value) {
                                if (value.length < 1) {
                                  return 'Mobile number cannot be empty';
                                }
                                return null;
                              }),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Landline:',
                            ),
                            initialValue: contact?.landLine ?? '',
                            onChanged: (value) {
                              contact?.landLine = value;
                            },
                            validator: (value) {
                              if (value.length < 1) {
                                return 'Landline cannot be empty';
                              }
                              return null;
                            },
                          ),
                          RaisedButton(
                            child: Text('Save'),
                            onPressed: () {
                              contact?.image = path ?? contact.image;
                              if (_formKey.currentState.validate()) {
                                contactFormBloc.add(contact?.contactId == null
                                    ? CreateContact(contact: contact)
                                    : UpdateContact(contact: contact));
                              }
                              Navigator.pop(context);
                            },
                          ),
                          RaisedButton(
                            child: Text('Delete'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                contactFormBloc
                                    .add(DeleteContact(contact: contact));
                                contactFormBloc.add(BackEvent());
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                  if (state is Error) {
                    return Center(
                      child: ErrorPage(
                        buttonText: 'Retry',
                        function: () {
                          contactListBloc.add(ContactListGet());
                        },
                        message: 'Something went wrong',
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
