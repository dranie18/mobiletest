/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 2/2/2020
 */

import 'dart:io';

import 'package:app/src/data/data_access_objects/offers_dao.dart';
import 'package:app/src/data/tables/offers_table.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

part 'app_database.g.dart';

AppDatabase _databaseInstance;

LazyDatabase _openConnection() {
  final databaseName = 'db.sqlite';
  return LazyDatabase(() async {
    final appDocsFolder = await getApplicationDocumentsDirectory();
    final dbFile = File(path.join(appDocsFolder.path, databaseName));
    return VmDatabase(dbFile);
  });
}

@UseMoor(
  tables: [OffersTable],
  daos: [OffersDao]
)
class AppDatabase extends _$AppDatabase {

  AppDatabase._() : super(_openConnection());

  static AppDatabase getInstance() {
    if (_databaseInstance == null) {
      _databaseInstance = AppDatabase._();
    }
    return _databaseInstance;
  }

  @override
  int get schemaVersion => 1;
}