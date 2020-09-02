import 'package:equatable/equatable.dart';
import 'package:flutter_contact/models/Contact.dart';

abstract class ContactsState extends Equatable {
  const ContactsState();

  @override
  List<Object> get props => [];
}

class ContactLoadInProgress extends ContactsState {}

class ContactsLoadSuccess extends ContactsState {
  final List<Contact> contacts;

  const ContactsLoadSuccess([this.contacts = const []]);

  @override
  List<Object> get props => [contacts];

  @override
  String toString() => 'ContactsLoadSuccess {contacts: $contacts}';
}

class ContactsLoadFailure extends ContactsState {}
