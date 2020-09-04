import 'package:flutter_contact/models/contact.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ContactFormState {
  final Contact contact;
  final String message;

  ContactFormState({this.contact, this.message});
}

class InitialContactFormState extends ContactFormState {}

class Loading extends ContactFormState {}

class Error extends ContactFormState {
  Error({@required String errorMessage}) : super(message: errorMessage);
}

class Loaded extends ContactFormState {
  Loaded({@required Contact contact}) : super(contact: contact);
}

class Success extends ContactFormState {
  Success({@required String successMessage}) : super(message: successMessage);
}
