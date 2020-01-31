/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

import 'package:app/src/models/address.dart';
import 'package:app/src/models/info.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/phone.dart';
import 'package:app/src/models/self_link.dart';
import 'package:meta/meta.dart';

class LeadDetails extends Offer {
  final double distance;
  final double leadPrice;
  final String authorEmail;

  final List<Info> infoList;

  final List<Phone> authorPhones;

  LeadDetails({
    @required this.distance,
    @required this.infoList,
    @required this.leadPrice,
    @required this.authorEmail,
    @required this.authorPhones,
    @required String requestTitle,
    @required String authorName,
    @required Address requestAddress,
  })  : assert(distance != null),
        assert(infoList != null),
        assert(leadPrice != null),
        assert(authorEmail != null),
        assert(authorPhones != null),
        super(
          status: null,
          creationDate: DateTime.now(),
          requestTitle: requestTitle,
          authorName: authorName,
          requestAddress: requestAddress,
          detailsLink: SelfLink.noLink(),
        );

  // assuming that we always have at least one phone in the list
  Phone getAuthorPhone() => authorPhones.first;
}
