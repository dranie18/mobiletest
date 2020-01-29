/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/models/offer.dart';
import 'package:app/src/models/operation_result.dart';

abstract class OffersDataSource {

  Future<OperationResult<List<Offer>, String>> getAllOffers();
}