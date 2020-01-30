/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/models/offer.dart';
import 'package:app/src/models/offer_details.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';

abstract class OffersRepository {
  Future<OperationResult<List<Offer>, String>> getAllOffers();

  Future<OperationResult<List<Offer>, String>> refreshOffers();

  Future<OperationResult<OfferDetails, String>> getOfferDetails(
      SelfLink offerDetailsLink);
}
