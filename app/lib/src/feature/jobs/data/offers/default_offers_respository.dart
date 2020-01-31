/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/offers/offers_data_source.dart';
import 'package:app/src/feature/jobs/data/offers/offers_respository.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/offer_details.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';

class DefaultOffersRepository implements OffersRepository {
  final OffersDataSource _remoteDataSource;

  DefaultOffersRepository(this._remoteDataSource)
      : assert(_remoteDataSource != null);

  SelfLink _refreshOffersLink;


  @override
  Future<OperationResult<List<Offer>, String>> getAllOffers() async {
    final result = await _remoteDataSource.getAllOffers();
    if (result.hasSucceeded) {
      _refreshOffersLink = result.data.refreshLink;
      return OperationResult.success(result.data.offers);
    }
    return OperationResult.failed(result.error);
  }

  @override
  Future<OperationResult<List<Offer>, String>> refreshOffers() async {
    ArgumentError.checkNotNull(_refreshOffersLink, 'refreshOffersLink');

    final result = await _remoteDataSource.refreshOffers(_refreshOffersLink);
    if (result.hasSucceeded) {
      _refreshOffersLink = result.data.refreshLink;
      return OperationResult.success(result.data.offers);
    }
    return OperationResult.failed(result.error);
  }

  @override
  Future<OperationResult<OfferDetails, String>> getOfferDetails(SelfLink offerDetailsLink) {
    return _remoteDataSource.getOfferDetails(offerDetailsLink);
  }

  @override
  Future<OperationResult<LeadDetails, String>> acceptOffer(SelfLink acceptOfferLink) {
    return _remoteDataSource.acceptOffer(acceptOfferLink);
  }
}
