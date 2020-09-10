import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/contact_form/bloc.dart';
import 'package:flutter_contact/bloc/contact_list/bloc.dart';
import 'package:flutter_contact/models/contact.dart';
import 'package:flutter_contact/utility/helper.dart';
import 'package:flutter_contact/views/widgets/error_page.dart';
import 'package:flutter_contact/views/widgets/user_image.dart';

class ContactDetail extends StatefulWidget {
  ContactDetail({Key key, this.fromFavourite}) : super(key: key);

  final bool fromFavourite;

  @override
  _ContactDetailState createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final _formKey = GlobalKey<FormState>();

  ContactsListBloc contactListBloc;

  ContactFormBloc contactFormBloc;

  bool isFav;

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
                  contactListBloc.add(ContactListGet(widget.fromFavourite));
                },
                child: BlocBuilder<ContactFormBloc, ContactFormState>(
                    builder: (context, state) {
                  if (state is Loaded) {
                    Contact contact = state.contact;
                    isFav = contact.isFavorite == 1;

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
                              final imagePath =
                                  await Helper().getImage(context);
                              contact.image = imagePath ?? contact.image;
                              // await getImage(context);
                              // contact.image = path;
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
                                return 'Landline number cannot be empty';
                              }
                              return null;
                            },
                          ),
                          CheckboxListTile(
                              title: Text('Favourite'),
                              value: isFav,
                              onChanged: (value) {
                                setState(() {
                                  isFav = value;
                                });
                                contact?.isFavorite = isFav ? 1 : 0;
                              }),
                          RaisedButton(
                            child: Text('Save'),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                contactFormBloc.add(contact?.contactId == null
                                    ? CreateContact(contact: contact)
                                    : UpdateContact(contact: contact));
                              }
                              Navigator.pop(context);
                            },
                          ),
                          getDeleteButton(contact),
                        ],
                      ),
                    );
                  }
                  if (state is Error) {
                    return Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: Center(
                        child: ErrorPage(
                          buttonText: 'Retry',
                          function: () {
                            contactListBloc
                                .add(ContactListGet(widget.fromFavourite));
                          },
                          message: 'Something went wrong',
                        ),
                      ),
                    );
                  }
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getDeleteButton(Contact contact) {
    return contact?.contactId != null
        ? RaisedButton(
            child: Text('Delete'),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                contactFormBloc.add(DeleteContact(contact: contact));
                contactFormBloc.add(BackEvent());
              }
              Navigator.pop(context);
            },
          )
        : SizedBox.shrink();
  }
}
