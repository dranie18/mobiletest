/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 2/2/2020
 */

import 'package:moor/moor.dart';

@DataClassName('DbOffer')
class OffersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get status => text()();
  TextColumn get authorName => text()();
  TextColumn get requestTitle => text()();
  DateTimeColumn get creationDate => dateTime()();

  TextColumn get detailsLinkHref => text()();

  TextColumn get addressJson => text()();

}