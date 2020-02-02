/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/feature/jobs/ui/jobs_page.dart';
import 'package:app/src/feature/jobs/ui/lead_details_page.dart';
import 'package:app/src/feature/jobs/ui/widgets/offer_card.dart';
import 'package:app/src/feature/jobs/view_models/leads_view_model.dart';
import 'package:app/src/models/lead.dart';
import 'package:app/src/ui/common/circular_progress_bar.dart';
import 'package:app/src/ui/common/network_error_view.dart';
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
      reaction((_) => _leadsViewModel.isRefreshing, (isRefreshing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isRefreshing)
          _refreshController.requestRefresh();
        else
          _refreshController.refreshCompleted();
      });
    }));
    disposers.add(
        reaction((_) => _leadsViewModel.hasData && _leadsViewModel.hasError,
            (showSnackBarError) {
      if (showSnackBarError) _showSnackBar(_leadsViewModel.errorMessage);
    }));
  }

  void _showSnackBar(String message) {
    jobsPageScaffoldKey.currentState.removeCurrentSnackBar();
    jobsPageScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(message))
    );
  }

  void _onLeadTap(BuildContext context, Lead lead) {
    Navigator.push(context, MaterialPageRoute(
        builder: (_) => LeadDetailsPage(leadDetailsLink: lead.detailsLink)
    ));
  }

  void _loadLeads() {
    _leadsViewModel.loadLeads();
  }

  @override
  void initState() {
    super.initState();
    _registerViewModelListeners();
    _loadLeads();
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

    return Observer(
      builder: (_) {
        return SmartRefresher(
          controller: _refreshController,
          enablePullDown: _leadsViewModel.canRefreshData,
          onRefresh: () => _leadsViewModel.refreshLeads(),
          child: Observer(
            builder: (_) {
              if (_leadsViewModel.isLoading)
                return Center(child: CircularProgressbar());
              if (_leadsViewModel.hasError && !_leadsViewModel.hasData)
                return NetworkErrorView(
                  _leadsViewModel.errorMessage,
                  onRetry: () => _loadLeads(),
                );
              if (_leadsViewModel.hasData)
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: _leadsViewModel.leads.length,
                  itemBuilder: (_, index) {
                    final item = _leadsViewModel.leads.elementAt(index);
                    return GestureDetector(
                      onTap: () => _onLeadTap(context, item),
                      child: OfferCard(offer: item),
                    );
                  },
                );
              return SizedBox.shrink();
            },
          ),
        );
      }
    );
  }
}

