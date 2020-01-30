/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

import 'package:app/src/models/offer.dart';
import 'package:app/src/ui/common/dashed_divider.dart';
import 'package:flutter/material.dart';

class OfferDetailsPage extends StatelessWidget {
  final Offer offer;

  const OfferDetailsPage({@required this.offer}) : assert(offer != null);

  final _answerButtonsHeight = 56.0;
  final _contentPadding = 16.0;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final answerButtonsStyle = textTheme.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Oferta'),
      ),
      body: Container(
        color: Theme.of(context).cardColor,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Placeholder(
              fallbackWidth: double.infinity,
              fallbackHeight: 150,
            ),
            Padding(
              padding: EdgeInsets.all(_contentPadding),
              child: Text(offer.requestTitle,
                  style: textTheme.title.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            const DashedDivider(padding: 16),
            _ContentArea(
              children: <Widget>[
                _TitleText(offer.authorName),
                _TitleText(offer.requestAddress.completeAddress),
              ],
            ),
            const DashedDivider(padding: 16),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child: MaterialButton(
              height: _answerButtonsHeight,
              color: Colors.grey,
              child: Text('Recusar', style: answerButtonsStyle),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: MaterialButton(
              height: _answerButtonsHeight,
              color: Colors.green,
              child: Text('Aceitar', style: answerButtonsStyle),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleText extends StatelessWidget {
  final String text;
  const _TitleText(this.text) : assert(text != null);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.subtitle.copyWith(
      fontWeight: FontWeight.bold
    ),);
  }
}


class _ContentArea extends StatelessWidget {
  final double padding;
  final List<Widget> children;

  const _ContentArea({Key key,
    this.padding = 16,
    @required this.children,
  })
      : assert(padding != null),
        assert(children != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: children),
    );
  }
}
