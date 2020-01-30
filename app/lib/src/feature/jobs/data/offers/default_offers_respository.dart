/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/offers/offers_data_source.dart';
import 'package:app/src/feature/jobs/data/offers/offers_respository.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';

class DefaultOffersRepository implements OffersRepository {
  final OffersDataSource remoteDataSource;

  DefaultOffersRepository(this.remoteDataSource)
      : assert(remoteDataSource != null);

  SelfLink refreshOffersLink;

  @override
  Future<OperationResult<List<Offer>, String>> getAllOffers() async {
    final result = await remoteDataSource.getAllOffers();
    if (result.hasSucceeded) {
      refreshOffersLink = result.data.refreshLink;
      return OperationResult.success(result.data.offers);
    }
    return OperationResult.failed(result.error);
  }

  @override
  Future<OperationResult<List<Offer>, String>> refreshOffers() async {
    ArgumentError.checkNotNull(refreshOffersLink, 'refreshOffersLink');

    final result = await remoteDataSource.refreshOffers(refreshOffersLink);
    if (result.hasSucceeded) {
      refreshOffersLink = result.data.refreshLink;
      return OperationResult.success(result.data.offers);
    }
    return OperationResult.failed(result.error);
  }

}
