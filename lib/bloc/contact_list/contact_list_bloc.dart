import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contact/bloc/contact_list/contact_list_event.dart';
import 'package:flutter_contact/bloc/contact_list/contact_list_state.dart';
import 'package:flutter_contact/database/contact_repository.dart';
import 'package:flutter_contact/models/contact.dart';

class ContactsListBloc extends Bloc<ContactsEvent, ContactsState> {
  final ContactRepository contactsRepository;
  ContactsListBloc(this.contactsRepository) : super(ContactLoadInProgress());

  @override
  Stream<ContactsState> mapEventToState(ContactsEvent event) async* {
    if (event is ContactListGet) {
      yield* _mapContactsLoadingState(event);
    } else if (event is ContactLoadSuccess) {
      yield* _mapContactsLoadedToState();
    } else if (event is ContactLoadFavourites) {
      yield* _mapContactsFavouriteLoadedToState();
    } else if (event is ContactAdded) {
      yield* _mapContactAddedToState(event);
    } else if (event is ContactUpdated) {
      yield* _mapContactUpdatedToState(event);
    } else if (event is ContactDeleted) {
      yield* _mapContactDeletedToState(event);
    } else if (event is ContactFavorite) {
      yield* _mapContactFavorite(event);
    }
  }

  Stream<ContactsState> _mapContactsLoadingState(ContactListGet event) async* {
    yield ContactLoadInProgress();
    try {
      // final contacts = await this.contactsRepository.contacts();
      // yield ContactsLoadSuccess(contacts);
      final contacts = event.fromFavourite
          ? await this.contactsRepository.favouriteContacts()
          : await this.contactsRepository.contacts();
      //final contacts = await this.contactsRepository.contacts();

      yield event.fromFavourite
          ? ContactsFavouriteLoadSuccess(contacts)
          : ContactsLoadSuccess(
              contacts,
            );
    } catch (_) {
      yield ContactsLoadFailure();
    }
  }

  Stream<ContactsState> _mapContactsLoadedToState() async* {
    try {
      final contacts = await this.contactsRepository.contacts();

      yield ContactsLoadSuccess(contacts);
    } catch (_) {
      yield ContactsLoadFailure();
    }
  }

  Stream<ContactsState> _mapContactsFavouriteLoadedToState() async* {
    try {
      final contacts = await this.contactsRepository.favouriteContacts();

      yield ContactsFavouriteLoadSuccess(contacts);
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
        contacts,
      );
    } catch (_) {
      yield ContactsLoadFailure();
    }
  }

  //Updating the favourite value of contact
  Stream<ContactsState> _mapContactUpdatedToState(ContactUpdated event) async* {
    yield ContactLoadInProgress();
    try {
      await this.contactsRepository.updateContactFavourite(event.contact);
      final contacts = event.fromFavourite
          ? await this.contactsRepository.favouriteContacts()
          : await this.contactsRepository.contacts();

      yield event.fromFavourite
          ? ContactsFavouriteLoadSuccess(contacts)
          : ContactsLoadSuccess(
              contacts,
            );
    } catch (_) {
      yield ContactsLoadFailure();
    }
  }

  Stream<ContactsState> _mapContactDeletedToState(ContactDeleted event) async* {
    yield ContactLoadInProgress();
    try {
      await this.contactsRepository.deleteContact(event.contact.contactId);
      final contacts = await this.contactsRepository.contacts();

      yield ContactsLoadSuccess(
        contacts,
      );
    } catch (_) {
      yield ContactsLoadFailure();
    }
  }

  Stream<ContactsState> _mapContactFavorite(ContactFavorite event) async* {
    yield ContactLoadInProgress();
    try {
      await this.contactsRepository.updateContactFavourite(event.contact);
      final contacts = await this.contactsRepository.contacts();

      yield ContactsLoadSuccess(
        contacts,
      );
    } catch (_) {
      yield ContactsLoadFailure();
    }
  }
}
