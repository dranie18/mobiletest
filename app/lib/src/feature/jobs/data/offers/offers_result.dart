/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/models/offer.dart';
import 'package:app/src/models/self_link.dart';

class OffersResult {
  final List<Offer> offers;
  final SelfLink refreshLink;

  OffersResult(this.offers, this.refreshLink)
      : assert(offers != null),
        assert(refreshLink != null);
}
