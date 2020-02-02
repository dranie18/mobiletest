/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 2/2/2020
 */

import 'package:app/src/data/data_access_objects/offers_dao.dart';
import 'package:app/src/exceptions/not_implemented_exception.dart';
import 'package:app/src/feature/jobs/data/offers/offers_data_source.dart';
import 'package:app/src/feature/jobs/data/offers/offers_result.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/offer_details.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';

class OffersLocalDataSource extends OffersDataSource {
  final OffersDao offersDao;

  OffersLocalDataSource(this.offersDao) : assert(offersDao != null);

  @override
  Future<OperationResult<OffersResult, String>> getAllOffers() async {
    final offers = await offersDao.getAllOffers();
    final data = OffersResult(offers, SelfLink.noLink());
    return OperationResult.success(data);
  }

  @override
  Future<void> saveAllOffers(OffersResult offersResult) async {
    //TODO: we are not saving {offersResult.refreshLink}
    return offersDao.saveAllOffers(offersResult.offers);
  }

  @override
  Future<OperationResult<OfferDetails, String>> getOfferDetails(
      SelfLink offerDetailsLink) {
    throw notImplementedException;
  }

  @override
  Future<OperationResult<OffersResult, String>> refreshOffers(
      SelfLink refreshLink) {
    throw notImplementedException;
  }

  @override
  Future<OperationResult<LeadDetails, String>> acceptOffer(
      SelfLink acceptOfferLink) {
    throw notImplementedException;
  }

  @override
  Future<OperationResult<OffersResult, String>> denyOffer(
      SelfLink denyOfferLink) {
    throw notImplementedException;
  }
}