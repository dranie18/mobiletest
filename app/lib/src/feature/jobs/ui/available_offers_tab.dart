/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/offers/offers_respository.dart';
import 'package:app/src/feature/jobs/ui/widgets/offer_card.dart';
import 'package:app/src/feature/jobs/view_models/offers_view_model.dart';
import 'package:app/src/ui/common/circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AvailableOffersTab extends StatefulWidget {
  @override
  _AvailableOffersTabState createState() => _AvailableOffersTabState();
}

class _AvailableOffersTabState extends State<AvailableOffersTab>
  with AutomaticKeepAliveClientMixin {
  final offersViewModel = OffersViewModel(injector.get<OffersRepository>());

  @override
  void initState() {
    super.initState();
    offersViewModel.loadAllOffers();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListView(
      primary: true,
      children: <Widget>[
        Observer(
          builder: (_) => Visibility(
            visible: offersViewModel.hasData,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 8),
              itemCount: offersViewModel.offers.length,
              itemBuilder: (_, index) {
                final item = offersViewModel.offers.elementAt(index);
                return OfferCard(offer: item);
              },
            ),
          ),
        ),
        Observer(
          builder: (_) => Visibility(
            visible: offersViewModel.hasError,
            child: Column(
              children: <Widget>[
                Text(offersViewModel.errorMessage, style: Theme.of(context).textTheme.headline,),
              ],
            ),
          ),
        ),
        Observer(
          builder: (_) => Visibility(
            visible: offersViewModel.isLoading,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressbar(),
              ),
            ),
          )
        )
      ],
    );
  }
}
