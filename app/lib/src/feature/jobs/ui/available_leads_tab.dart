/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/feature/jobs/ui/widgets/offer_card.dart';
import 'package:app/src/feature/jobs/view_models/leads_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AvailableLeadsTab extends StatefulWidget {
  @override
  _AvailableLeadsTabState createState() => _AvailableLeadsTabState();
}

class _AvailableLeadsTabState extends State<AvailableLeadsTab>
  with AutomaticKeepAliveClientMixin {
  final _leadsViewModel = LeadsViewModel(injector.get<LeadsRepository>());
  final List<ReactionDisposer> disposers = [];

  final RefreshController _refreshController = RefreshController();

  void _registerViewModelListeners() {
    disposers.add(
      reaction((_) => _leadsViewModel.isLoading, (isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isLoading)
          _refreshController.requestRefresh();
        else
          _refreshController.refreshCompleted();
      });
    })
    );
  }

  @override
  void initState() {
    super.initState();
    _registerViewModelListeners();
    _leadsViewModel.loadLeads();
  }

  @override
  void dispose() {
    disposers.forEach((disposer) => disposer());
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SmartRefresher(
      controller: _refreshController,
      onRefresh: () => _leadsViewModel.refreshLeads(),
      child: ListView(
        primary: true,
        children: <Widget>[
          Observer(
            builder: (_) => Visibility(
              visible: _leadsViewModel.hasData,
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
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
        ],
      ),
    );
  }
}
