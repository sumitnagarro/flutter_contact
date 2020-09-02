import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/contact_list/contact_list_event.dart';
import 'package:flutter_contact/bloc/contact_list/contact_list_state.dart';
import 'package:flutter_contact/database/contact_repository.dart';
import 'package:flutter_contact/models/Contact.dart';

class ContactsListBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactRepository contactsRepository;
  ContactsListBloc(this.contactsRepository) : super(ContactLoadInProgress());

  // @override
  // ContactListState get initialState => ContactListState();

  @override
  Stream<ContactsState> mapEventToState(ContactsEvent event) async* {
    if (event is ContactListGet) {
      yield* _mapContactsLoadingState();
    } else if (event is ContactsLoadSuccess) {
      yield* _mapContactsLoadedToState();
    } else if (event is ContactAdded) {
      yield* _mapContactAddedToState(event);
    } else if (event is ContactUpdated) {
      yield* _mapContactUpdatedToState(event);
    } else if (event is ContactDeleted) {
      yield* _mapContactDeletedToState(event);
    }

    // else if (event is ContactFavorite) {
    //   yield* _mapContactFavorite();
    // }
  }

  Stream<ContactsState> _mapContactsLoadingState() async* {
    yield ContactLoadInProgress();
    try {
      final contacts = await this.contactsRepository.contacts();
      yield ContactsLoadSuccess(
        //contacts.map(Contact.fromEntity).toList(),
        contacts,
      );
    } catch (_) {
      yield ContactsLoadFailure();
    }
  }

  Stream<ContactsState> _mapContactsLoadedToState() async* {
    try {
      final contacts = await this.contactsRepository.contacts();
      yield ContactsLoadSuccess(
        //contacts.map(Contact.fromEntity).toList(),
        contacts,
      );
    } catch (_) {
      yield ContactsLoadFailure();
    }
  }

  Stream<ContactsState> _mapContactAddedToState(ContactAdded event) async* {
    yield ContactLoadInProgress();
    try {
      await this.contactsRepository.insertContact(event.contact);
      final contacts = await this.contactsRepository.contacts();
      yield ContactsLoadSuccess(
        //contacts.map(Contact.fromEntity).toList(),
        contacts,
      );
    } catch (_) {
      yield ContactsLoadFailure();
    }
    // if (state is ContactsLoadSuccess) {
    //   final List<Contact> updatedContacts =
    //       List.from((state as ContactsLoadSuccess).contacts)
    //         ..add(event.contact);
    //   yield ContactsLoadSuccess(updatedContacts);
    //   _saveContacts(updatedContacts);
    // }
  }

  Stream<ContactsState> _mapContactUpdatedToState(ContactUpdated event) async* {
    if (state is ContactsLoadSuccess) {
      final List<Contact> updatedContacts =
          (state as ContactsLoadSuccess).contacts.map((contact) {
        return contact.contactId == event.contact.contactId
            ? event.contact
            : contact;
      }).toList();
      yield ContactsLoadSuccess(updatedContacts);
      _saveContacts(updatedContacts);
    }
  }

  Stream<ContactsState> _mapContactDeletedToState(ContactDeleted event) async* {
    if (state is ContactsLoadSuccess) {
      final updatedContacts = (state as ContactsLoadSuccess)
          .contacts
          .where((contact) => contact.contactId != event.contact.contactId)
          .toList();
      yield ContactsLoadSuccess(updatedContacts);
      _saveContacts(updatedContacts);
    }
  }

  // Stream<ContactsState> _mapContactFavorite() async* {
  //   if (state is ContactsLoadSuccess) {
  //     final allComplete =
  //         (state as ContactsLoadSuccess).Contacts.every((Contact) => Contact.complete);
  //     final List<Contact> updatedContacts = (state as ContactsLoadSuccess)
  //         .contacts
  //         .map((Contact) => Contact.copyWith(complete: !allComplete))
  //         .toList();
  //     yield ContactsLoadSuccess(updatedContacts);
  //     _saveContacts(updatedContacts);
  //   }
  // }

  Future _saveContacts(List<Contact> contacts) {
    // return contactsRepository.insertContact(
    //   contacts.map((contact) => contact.toEntity()).toList(),
    // );
  }
}
