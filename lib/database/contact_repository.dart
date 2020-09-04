import 'package:flutter_contact/constant/constants.dart';
import 'package:flutter_contact/database/database_helper.dart';
import 'package:flutter_contact/models/contact.dart';
import 'package:sqflite/sqflite.dart';

class ContactRepository {
  final DatabaseHelper databaseHelper = DatabaseHelper();
  static final ContactRepository _contactRepository =
      ContactRepository._internal();

  factory ContactRepository() {
    return _contactRepository;
  }

  ContactRepository._internal();

  Future<int> insertContact(Contact contact) async {
    // Get a reference to the database.
    Database db = await databaseHelper.db;

    // Insert the Contact into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Contact is inserted twice.
    //
    // In this case, replace any previous data.
    var result = await db.insert(
      kContactTableName,
      contact.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<Contact> getContact(int id) async {
    // Get a reference to the database.
    final db = await databaseHelper.db;
    // Query the table for all The Contacts.
    var result = await db
        .query(kContactTableName, where: 'contactId = ?', whereArgs: [id]);

    List<Contact> contacts = result.isNotEmpty
        ? result.map((user) => Contact.fromJson(user)).toList()
        : [];
    //Return first contact in the list
    Contact contact = contacts.isNotEmpty ? contacts.first : null;
    return contact;
  }

  Future<List<Contact>> contacts() async {
    // Get a reference to the database.
    Database db = await databaseHelper.db;

    // Query the table for all The Contacts.
    final List<Map<String, dynamic>> maps = await db.query(kContactTableName);

    List<Contact> contacts = maps.isNotEmpty
        ? maps.map((item) => Contact.fromJson(item)).toList()
        : [];
    return contacts;
  }

  Future<void> updateContact(Contact contact) async {
    // Get a reference to the database.
    Database db = await databaseHelper.db;

    // Update the given Contact.
    await db.update(
      kContactTableName,
      contact.toJson(),
      // Ensure that the Contact has a matching contactId.
      where: "contactId = ?",
      // Pass the Contact's contactId as a whereArg to prevent SQL injection.
      whereArgs: [contact.contactId],
    );
  }

  Future<void> deleteContact(int contactId) async {
    // Get a reference to the database.
    Database db = await databaseHelper.db;

    // Remove the Contact from the database.
    await db.delete(
      kContactTableName,
      // Use a `where` clause to delete a specific Contact.
      where: "contactId = ?",
      // Pass the Contact's contactId as a whereArg to prevent SQL injection.
      whereArgs: [contactId],
    );
  }
}
