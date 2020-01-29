/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/models/address.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/self_link.dart';
import 'package:meta/meta.dart';

class Lead extends Offer {
  final String authorCellphone;
  final String authorEmail;

  Lead({
    @required String requestTitle,
    @required DateTime creationDate,
    @required String authorName,
    @required Address requestAddress,
    @required SelfLink offerDetailsLink,
    @required this.authorCellphone,
    @required this.authorEmail,
  })  : assert(authorCellphone != null),
        assert(authorEmail != null),
        super(
          status: null,
          requestTitle: requestTitle,
          creationDate: creationDate,
          authorName: authorName,
          offerDetailsLink: offerDetailsLink,
          requestAddress: requestAddress,
        );
}
