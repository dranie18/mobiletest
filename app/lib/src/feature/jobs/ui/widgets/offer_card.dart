/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/models/offer.dart';
import 'package:app/src/ui/common/dashed_divider.dart';
import 'package:app/src/utils/date_time_utils.dart';
import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final Offer offer;

  const OfferCard({Key key, @required this.offer})
      : assert(offer != null),
        super(key: key);

  String _formatDate() => DateTimeUtils.date(offer.creationDate);

  @override
  Widget build(BuildContext context) {
    final statusColor = offer.isLead
        ? Colors.green
        : offer.status.wasRead ? Colors.grey : Theme.of(context).accentColor;
    final style = Theme.of(context).textTheme.subhead.copyWith(
      color: Colors.black54
    );

    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4
          )
        ]
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(offer.requestTitle,
                style: Theme.of(context).textTheme.headline.copyWith(
                    fontWeight: FontWeight.bold
                ),
              ),
              _OfferStatusIcon(color: statusColor),
            ],
          ),
          const DashedDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(offer.authorName, style: style,),
              Text(_formatDate(), style: style),
            ],
          ),
          Text(offer.requestAddress.completeAddress, style: style),
        ],
      ),
    );
  }
}

class _OfferStatusIcon extends StatelessWidget {
  final Color color;

  const _OfferStatusIcon({Key key, this.color}) :
        assert(color != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Size.fromRadius(8);
    return SizedBox.fromSize(
      size: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
        ),
      ),
    );
  }
}

