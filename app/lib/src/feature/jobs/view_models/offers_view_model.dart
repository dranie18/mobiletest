/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/feature/jobs/data/offers/offers_respository.dart';
import 'package:app/src/models/offer.dart';
import 'package:mobx/mobx.dart';

part 'offers_view_model.g.dart';

class OffersViewModel = _OffersViewModelBase with _$OffersViewModel;

abstract class _OffersViewModelBase with Store {
  final OffersRepository _offersRepository;

  _OffersViewModelBase(this._offersRepository)
      : assert(_offersRepository != null);

  static final _defaultErrorMessage = '';

  @observable
  List<Offer> offers = [];

  @observable
  bool isLoading = false;

  @observable
  bool isRefreshing = false;

  @observable
  String errorMessage = _defaultErrorMessage;

  @computed
  bool get hasData => offers.isNotEmpty;

  @computed
  bool get hasError => errorMessage != _defaultErrorMessage;

  @action
  void loadAllOffers() {
    if (isLoading || isRefreshing) {
      return;
    }

    isLoading = true;
    errorMessage = _defaultErrorMessage;

    _offersRepository.getAllOffers().then((result) {
      isLoading = result.isPending;

      if (result.hasSucceeded) {
        offers = result.data;
      } else if (result.hasFailed) {
        errorMessage = result.error;
      }
    });
  }

  @action
  void refreshOffers() {
    if (isLoading || isRefreshing || !hasData) {
      return;
    }

    isRefreshing = true;
    errorMessage = _defaultErrorMessage;

    _offersRepository.refreshOffers().then((result) {
      isRefreshing = result.isPending;

      if (result.hasSucceeded) {
        offers = result.data;
      } else if (result.hasFailed) {
        errorMessage = result.error;
      }
    });
  }
}
