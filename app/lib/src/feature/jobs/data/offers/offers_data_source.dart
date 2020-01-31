/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/offers/offers_result.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/offer_details.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';

abstract class OffersDataSource {

  Future<OperationResult<OffersResult, String>> getAllOffers();

  Future<OperationResult<OffersResult, String>> refreshOffers(
      SelfLink refreshLink);

  Future<OperationResult<OfferDetails, String>> getOfferDetails(SelfLink offerDetailsLink);

  Future<OperationResult<LeadDetails, String>> acceptOffer(SelfLink acceptOfferLink);
}