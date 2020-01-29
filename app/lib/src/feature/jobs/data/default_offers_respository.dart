/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/feature/jobs/data/offers_data_source.dart';
import 'package:app/src/feature/jobs/data/offers_respository.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/operation_result.dart';

class DefaultOffersRepository implements OffersRepository {
  final OffersDataSource remoteDataSource;

  DefaultOffersRepository(this.remoteDataSource)
      : assert(remoteDataSource != null);

  @override
  Future<OperationResult<List<Offer>, String>> getAllOffers() {
    // TODO: implement getAllOffers
    return remoteDataSource.getAllOffers();
  }
}
