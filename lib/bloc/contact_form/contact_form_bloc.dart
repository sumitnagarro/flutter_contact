import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_contact/database/contact_repository.dart';
import 'package:flutter_contact/models/contact.dart';
import './bloc.dart';

class ContactFormBloc extends Bloc<ContactFormEvent, ContactFormState> {
  final ContactRepository contactsRepository;

  ContactFormBloc(this.contactsRepository) : super(InitialContactFormState());

  @override
  Stream<ContactFormState> mapEventToState(ContactFormEvent event) async* {
    yield Loading();
    if (event is GetContact) {
      try {
        yield Loaded(
            contact: event.contact?.contactId == null
                ? Contact()
                : await contactsRepository
                    .getContact(event.contact?.contactId));
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } else if (event is BackEvent) {
      yield InitialContactFormState();
    } else if (event is CreateContact) {
      try {
        await contactsRepository.insertContact(event.contact);
        yield Success(successMessage: event.contact.name + ' created.');
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } else if (event is UpdateContact) {
      try {
        await contactsRepository.updateContact(event.contact);
        yield Success(successMessage: event.contact.name + ' updated.');
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } else if (event is DeleteContact) {
      try {
        await contactsRepository.deleteContact(event.contact.contactId);
        yield Success(successMessage: event.contact.name + ' deleted.');
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    } else if (event is PickContactImage) {
      try {
        yield Loaded(contact: event.contact);
      } catch (e) {
        yield Error(errorMessage: e.toString());
      }
    }
  }
}
