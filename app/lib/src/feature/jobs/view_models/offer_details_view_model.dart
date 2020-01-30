/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

import 'package:app/src/feature/jobs/data/offers/offers_respository.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/offer_details.dart';
import 'package:mobx/mobx.dart';

part 'offer_details_view_model.g.dart';

class OfferDetailsViewModel = _OfferDetailsViewModelBase
    with _$OfferDetailsViewModel;

abstract class _OfferDetailsViewModelBase with Store {
  final OffersRepository _offersRepository;

  _OfferDetailsViewModelBase(this._offersRepository)
      : assert(_offersRepository != null);

  static final _defaultErrorMessage = '';

  @observable
  OfferDetails offerDetails;

  @computed
  bool get hasData => offerDetails != null;

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = _defaultErrorMessage;

  @computed
  bool get hasError => errorMessage != _defaultErrorMessage;

  @action
  void loadOfferDetails(Offer offer) {
    isLoading = true;
    errorMessage = _defaultErrorMessage;

    _offersRepository.getOfferDetails(offer.detailsLink).then((result) {
      isLoading = result.isPending;

      if (result.hasSucceeded) {
        offerDetails = result.data;
      } else if (result.hasFailed) {
        errorMessage = result.error;
      }
    });
  }
}
