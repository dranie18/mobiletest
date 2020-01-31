/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

import 'package:app/src/feature/jobs/data/offers/offers_respository.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/offer_details.dart';
import 'package:app/src/models/self_link.dart';
import 'package:mobx/mobx.dart';

part 'offer_details_view_model.g.dart';

class OfferDetailsViewModel = _OfferDetailsViewModelBase
    with _$OfferDetailsViewModel;

abstract class _OfferDetailsViewModelBase with Store {
  final OffersRepository _offersRepository;
  final AcceptOfferViewModel acceptOfferViewModel;
  final DenyOfferViewModel denyOfferViewModel;

  _OfferDetailsViewModelBase(this._offersRepository)
      : assert(_offersRepository != null),
        acceptOfferViewModel = AcceptOfferViewModel(_offersRepository),
        denyOfferViewModel = DenyOfferViewModel(_offersRepository);

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

  @action
  void acceptOffer() {
    if (hasData) {
      acceptOfferViewModel.acceptOffer(offerDetails.acceptOfferLink);
    }
  }

  void denyOffer() {
    if (hasData) {
      denyOfferViewModel.denyOffer(offerDetails.rejectOfferLink);
    }
  }
}

class AcceptOfferViewModel = _AcceptOfferViewModelBase with _$AcceptOfferViewModel;

abstract class _AcceptOfferViewModelBase with Store {
  final OffersRepository _offersRepository;

  _AcceptOfferViewModelBase(this._offersRepository)
      : assert(_offersRepository != null);

  static final _defaultErrorMessage = '';

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = _defaultErrorMessage;

  @observable
  bool isOfferAccepted = false;

  @computed
  bool get hasError => errorMessage != _defaultErrorMessage;

  @observable
  LeadDetails acceptedOffer;

  @action
  void acceptOffer(SelfLink acceptOfferLink) {
    ArgumentError.checkNotNull(acceptOfferLink);

    isLoading = true;
    errorMessage = _defaultErrorMessage;

    _offersRepository.acceptOffer(acceptOfferLink).then((result) {
      isLoading = false;
      if (result.hasSucceeded) {
        acceptedOffer = result.data;
        isOfferAccepted = result.hasSucceeded;
      } else if (result.hasFailed) {
        errorMessage = result.error;
      }
    });
  }
}

class DenyOfferViewModel = _DenyOfferViewModelBase with _$DenyOfferViewModel;

abstract class _DenyOfferViewModelBase with Store {
  final OffersRepository _offersRepository;

  _DenyOfferViewModelBase(this._offersRepository)
      : assert(_offersRepository != null);

  static final _defaultErrorMessage = '';

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = _defaultErrorMessage;

  @observable
  bool isOfferDenied = false;

  @computed
  bool get hasError => errorMessage != _defaultErrorMessage;

  @action
  void denyOffer(SelfLink denyOfferLink) {
    ArgumentError.checkNotNull(denyOfferLink);

    isLoading = true;
    errorMessage = _defaultErrorMessage;

    _offersRepository.denyOffer(denyOfferLink).then((result) {
      isLoading = false;
      if (result.hasSucceeded) {
        isOfferDenied = result.hasSucceeded;
      } else if (result.hasFailed) {
        errorMessage = result.error;
      }
    });
  }
}
