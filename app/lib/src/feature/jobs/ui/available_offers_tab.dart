/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/offers/offers_respository.dart';
import 'package:app/src/feature/jobs/ui/jobs_page.dart';
import 'package:app/src/feature/jobs/ui/offer_details_page.dart';
import 'package:app/src/feature/jobs/ui/widgets/offer_card.dart';
import 'package:app/src/feature/jobs/view_models/offers_view_model.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/ui/common/circular_progress_bar.dart';
import 'package:app/src/ui/common/network_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AvailableOffersTab extends StatefulWidget {
  @override
  _AvailableOffersTabState createState() => _AvailableOffersTabState();
}

class _AvailableOffersTabState extends State<AvailableOffersTab>
  with AutomaticKeepAliveClientMixin {
  final _offersViewModel = OffersViewModel(injector.get<OffersRepository>());
  final List<ReactionDisposer> disposers = [];

  final RefreshController _refreshController = RefreshController();

  void _registerViewModelListeners() {
    disposers.add(reaction<bool>((_) => _offersViewModel.isRefreshing, (isRefreshing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isRefreshing) {
          _refreshController.requestRefresh();
        } else {
          _refreshController.refreshCompleted();
        }
      });
    }));
    disposers.add(
        reaction((_) => _offersViewModel.hasError && _offersViewModel.hasData,
            (showErrorMessage) {
      if (showErrorMessage) _showSnackBar(_offersViewModel.errorMessage);
    }));
  }

  void _showSnackBar(String message) {
    jobsPageScaffoldKey.currentState.removeCurrentSnackBar();
    jobsPageScaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(message))
    );
  }

  void _onOfferTap(BuildContext context, Offer offer) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => OfferDetailsPage(offer: offer)
    ));
  }

  void _loadOffers() {
    _offersViewModel.loadAllOffers();
  }

  @override
  void initState() {
    super.initState();
    _registerViewModelListeners();
    _loadOffers();
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
          enablePullDown: _offersViewModel.canRefreshData,
          onRefresh: () => _offersViewModel.refreshOffers(),
          child: Observer(
            builder: (_) {
              if (_offersViewModel.isLoading)
                return Center(child: CircularProgressbar());
              if (_offersViewModel.hasError && !_offersViewModel.hasData)
                return NetworkErrorView(
                  _offersViewModel.errorMessage,
                  onRetry: () => _loadOffers(),
                );
              if (_offersViewModel.hasData)
                return ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: const EdgeInsets.only(top: 8),
                  itemCount: _offersViewModel.offers.length,
                  itemBuilder: (context, index) {
                    final item = _offersViewModel.offers.elementAt(index);
                    return GestureDetector(
                        onTap: () => _onOfferTap(context, item),
                        child: OfferCard(offer: item));
                  },
                );
              return SizedBox.shrink();
            }
          ),
        );
      }
    );
  }
}
