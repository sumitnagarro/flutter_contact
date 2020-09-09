import 'package:flutter_contact/models/contact.dart';
import 'package:equatable/equatable.dart';

abstract class ContactsEvent extends Equatable {
  const ContactsEvent();

  @override
  List<Object> get props => [];
}

class ContactListGet extends ContactsEvent {
  final List<Contact> contacts;
  //Adding bool from fromFavourite
  final bool fromFavourite;
  const ContactListGet(this.fromFavourite, [this.contacts = const []]);
  @override
  List<Object> get props => [contacts];

  @override
  String toString() => 'ContactLoaded {contact: $contacts}';
}

class ContactLoadSuccess extends ContactsEvent {}

class ContactLoadFavourites extends ContactsEvent {}

class ContactAdded extends ContactsEvent {
  final Contact contact;
  const ContactAdded(this.contact);

  @override
  List<Object> get props => [contact];

  @override
  String toString() => 'ContactAdded {contact: $contact}';
}

class ContactUpdated extends ContactsEvent {
  final Contact contact;
  final bool fromFavourite;
  const ContactUpdated(this.contact, {this.fromFavourite});
  //const ContactUpdated(this.contact);

  @override
  List<Object> get props => [contact];

  @override
  String toString() => 'ContactUpdated {contact: $contact}';
}

class ContactDeleted extends ContactsEvent {
  final Contact contact;
  const ContactDeleted(this.contact);

  @override
  List<Object> get props => [contact];

  @override
  String toString() => 'ContactDeleted {contact: $contact}';
}

class ContactFavorite extends ContactsEvent {
  final Contact contact;
  const ContactFavorite(this.contact);

  @override
  List<Object> get props => [contact];

  @override
  String toString() => 'ContactDeleted {contact id: $contact}';
}
