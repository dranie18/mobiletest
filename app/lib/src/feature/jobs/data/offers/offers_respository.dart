/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/offer_details.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';

abstract class OffersRepository {
  Stream<OperationResult<List<Offer>, String>> getAllOffers();

  Future<OperationResult<List<Offer>, String>> refreshOffers();

  Future<OperationResult<OfferDetails, String>> getOfferDetails(
      SelfLink offerDetailsLink);

  Future<OperationResult<LeadDetails, String>> acceptOffer(SelfLink acceptOfferLink);

  Future<OperationResult<void, String>> denyOffer(SelfLink denyOfferLink);
}
