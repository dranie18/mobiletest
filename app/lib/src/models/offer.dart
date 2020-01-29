/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/models/address.dart';
import 'package:app/src/models/self_link.dart';
import 'package:app/src/models/offer_status.dart';
import 'package:meta/meta.dart';

class Offer {
  final String requestTitle;
  final OfferStatus status;
  final DateTime creationDate;
  final String authorName;
  final Address requestAddress;

  final SelfLink offerDetailsLink;

  Offer({
    @required this.requestTitle,
    @required this.status,
    @required this.creationDate,
    @required this.authorName,
    @required this.requestAddress,
    @required this.offerDetailsLink,
  })  : assert(requestTitle != null),
        assert(status != null),
        assert(creationDate != null),
        assert(authorName != null),
        assert(requestAddress != null),
        assert(offerDetailsLink != null);
}
