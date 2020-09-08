import 'package:flutter_contact/models/contact.dart';
import 'package:meta/meta.dart';

abstract class ContactFormEvent {
  final Contact contact;

  ContactFormEvent({this.contact});
}

class BackEvent extends ContactFormEvent {}

class GetContact extends ContactFormEvent {
  GetContact({Contact contact}) : super(contact: contact);
}

class CreateContact extends ContactFormEvent {
  CreateContact({@required Contact contact}) : super(contact: contact);
}

class UpdateContact extends ContactFormEvent {
  UpdateContact({@required Contact contact}) : super(contact: contact);
}

class DeleteContact extends ContactFormEvent {
  final Contact contact;
  DeleteContact({@required this.contact}) : super(contact: contact);
}

class PickContactImage extends ContactFormEvent {}
