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
import 'package:app/src/models/operation_status.dart';
import 'package:app/src/models/self_link.dart';

class DefaultOffersRepository implements OffersRepository {
  final OffersDataSource remoteDataSource;
  final OffersDataSource localDataSource;

  DefaultOffersRepository({this.remoteDataSource, this.localDataSource})
      : assert(remoteDataSource != null),
        assert(localDataSource != null);

  SelfLink _refreshOffersLink;

  @override
  Stream<OperationResult<List<Offer>, String>> getAllOffers() async* {
    final cache = await localDataSource.getAllOffers();
    if (cache.data.offers.isNotEmpty) {
      _refreshOffersLink = cache.data.refreshLink;
      yield OperationResult.success(cache.data.offers);
    }

    final result = await remoteDataSource.getAllOffers();
    if (result.hasSucceeded) {
      _refreshOffersLink = result.data.refreshLink;
      await localDataSource.saveAllOffers(result.data);
      final databaseData = await localDataSource.getAllOffers();
      yield OperationResult.success(databaseData.data.offers);
    } else if (result.hasFailed) {
      yield OperationResult(
        data: cache.data.offers,
        error: result.error,
        status: OperationStatus.failed
      );
    }
  }

  @override
  Future<OperationResult<List<Offer>, String>> refreshOffers() async {
    ArgumentError.checkNotNull(_refreshOffersLink, 'refreshOffersLink');

    final result = await remoteDataSource.refreshOffers(_refreshOffersLink);
    if (result.hasSucceeded) {
      //TODO: update local data
      _refreshOffersLink = result.data.refreshLink;
      return OperationResult.success(result.data.offers);
    }
    return OperationResult.failed(result.error);
  }

  @override
  Future<OperationResult<OfferDetails, String>> getOfferDetails(SelfLink offerDetailsLink) {
    return remoteDataSource.getOfferDetails(offerDetailsLink);
  }

  @override
  Future<OperationResult<LeadDetails, String>> acceptOffer(SelfLink acceptOfferLink) {
    return remoteDataSource.acceptOffer(acceptOfferLink);
  }

  @override
  Future<OperationResult<void, String>> denyOffer(SelfLink denyOfferLink) async {
    final result = await remoteDataSource.denyOffer(denyOfferLink);
    if (result.hasSucceeded) {
      return OperationResult.success(null);
    }
    return OperationResult.failed(result.error);
  }
}
