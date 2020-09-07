import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/contact_form/bloc.dart';
import 'package:flutter_contact/bloc/contact_list/bloc.dart';
import 'package:flutter_contact/models/contact.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  //Picking image
  File _image;
  final picker = ImagePicker();
  String path;
  PickedFile imagePicked;
  Future getImage() async {
    imagePicked = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      path = imagePicked.path;
      _image = File(imagePicked.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    contactListBloc = BlocProvider.of<ContactsListBloc>(context);
    contactFormBloc = BlocProvider.of<ContactFormBloc>(context);
    return Scaffold(
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
                  Contact contact = state.contact?.contactId == null
                      ? Contact()
                      : state.contact;
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Center(
                            child: contact == null
                                ? Text('No image selected')
                                : CircleAvatar(
                                    radius: 100,
                                    backgroundImage:
                                        Image.file(File(contact?.image)).image,
                                  ),
                          ),
                          onTap: getImage,
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
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Mobile number:',
                            ),
                            initialValue:
                                contact?.mobileNumber.toString() ?? '',
                            onChanged: (value) {
                              contact?.mobileNumber = int.tryParse(value);
                            },
                            validator: (value) {
                              if (value.length < 1) {
                                return 'Mobile number cannot be empty';
                              }
                              return null;
                            }),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Landline:',
                          ),
                          initialValue: contact?.mobileNumber.toString() ?? '',
                          onChanged: (value) {
                            contact?.mobileNumber = int.tryParse(value);
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
                        )
                      ],
                    ),
                  );
                }
                if (state is Error) {
                  return error(state.message);
                }
                return loading();
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget error(String message) {
    return Text('Error happed $message');
  }

  Widget loading() {
    return CircularProgressIndicator();
  }
}
