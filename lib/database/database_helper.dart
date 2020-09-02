import 'dart:async';

import 'package:flutter_contact/constant/constants.dart';
import 'package:flutter_contact/constant/sql_command.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  DatabaseHelper._internal();

  Database database;

  Future<Database> get db async {
    if (database == null) database = await createDatabase();
    return database;
  }

  createDatabase() async {
    return await openDatabase(
      // Set the path to the database.
      join(await getDatabasesPath(), kDBName),
      // When the database is first created, create a table to store Ts.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          kCreateContactTable,
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  // Future<void> insert<T>(T t) async {
  //   // Get a reference to the database.

  //   // Insert the T into the correct table. You might also specify the
  //   // `conflictAlgorithm` to use in case the same T is inserted twice.
  //   //
  //   // In this case, replace any previous data.
  //   await database.insert(
  //     'Ts',
  //     T.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }
}
