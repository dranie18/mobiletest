/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/feature/jobs/ui/widgets/offer_card.dart';
import 'package:app/src/feature/jobs/view_models/leads_view_model.dart';
import 'package:app/src/ui/common/circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class AvailableLeadsTab extends StatefulWidget {
  @override
  _AvailableLeadsTabState createState() => _AvailableLeadsTabState();
}

class _AvailableLeadsTabState extends State<AvailableLeadsTab>
  with AutomaticKeepAliveClientMixin {
  final _leadsViewModel = LeadsViewModel(injector.get<LeadsRepository>());

  @override
  void initState() {
    super.initState();
    _leadsViewModel.loadLeads();
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
            visible: _leadsViewModel.hasData,
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 8),
              itemCount: _leadsViewModel.leads.length,
              itemBuilder: (_, index) {
                final item = _leadsViewModel.leads.elementAt(index);
                return OfferCard(offer: item);
              },
            ),
          ),
        ),
        Observer(
          builder: (_) => Visibility(
            visible: _leadsViewModel.hasError,
            child: Column(
              children: <Widget>[
                Text(
                  _leadsViewModel.errorMessage,
                  style: Theme.of(context).textTheme.headline,
                ),
              ],
            ),
          ),
        ),
        Observer(
            builder: (_) => Visibility(
              visible: _leadsViewModel.isLoading,
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
