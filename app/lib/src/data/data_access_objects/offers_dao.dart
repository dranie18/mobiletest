/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 2/2/2020
 */

import 'dart:convert';

import 'package:app/src/data/app_database.dart';
import 'package:app/src/data/tables/offers_table.dart';
import 'package:app/src/models/address.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/offer_status.dart';
import 'package:app/src/models/self_link.dart';
import 'package:moor/moor.dart';

part 'offers_dao.g.dart';

@UseDao(tables: [OffersTable])
class OffersDao extends DatabaseAccessor<AppDatabase> with _$OffersDaoMixin {
  OffersDao(AppDatabase db) : super(db);

  Future<void> saveAllOffers(List<Offer> offers) async {
    final offerRows = offers.map((offer) => OffersTableCompanion.insert(
        requestTitle: offer.requestTitle,
        authorName: offer.authorName,
        status: offer.status.status,
        detailsLinkHref: offer.detailsLink.href,
        creationDate: offer.creationDate,
        addressJson: json.encode(offer.requestAddress.toJson())
    )).toList();

    await delete(offersTable).go();

    await batch((batch) {
      batch.insertAll(offersTable, offerRows);
    });
  }

  Future<List<Offer>> getAllOffers() async {
    final data = await select(offersTable).get();
    if (data != null && data.isNotEmpty) {
      final offers = data.map((offer) => Offer(
          requestTitle: offer.requestTitle,
          authorName: offer.authorName,
          status: OfferStatus(offer.status),
          detailsLink: SelfLink(offer.detailsLinkHref),
          creationDate: offer.creationDate,
          requestAddress: Address.fromJson(json.decode(offer.addressJson))
      )).toList();
      return offers;
    }
    return [];
  }
}