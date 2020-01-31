/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/self_link.dart';
import 'package:app/src/utils/app_launcher_helper.dart';
import 'package:mobx/mobx.dart';

part 'lead_details_view_model.g.dart';

class LeadDetailsViewModel = _LeadDetailsViewModelBase
    with _$LeadDetailsViewModel;

abstract class _LeadDetailsViewModelBase with Store {
  final LeadsRepository _leadsRepository;

  _LeadDetailsViewModelBase(this._leadsRepository)
      : assert(_leadsRepository != null);

  static final _defaultErrorMessage = '';

  @observable
  LeadDetails offerDetails;

  @computed
  bool get hasData => offerDetails != null;

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = _defaultErrorMessage;

  @computed
  bool get hasError => errorMessage != _defaultErrorMessage;

  @observable
  bool errorLaunchingWhatsApp = false;

  @action
  void setLeadDetails(LeadDetails leadDetails) {
    this.offerDetails = leadDetails;
  }

  @action
  void loadLeadDetails(SelfLink leadDetailsLink) {
    ArgumentError.checkNotNull(leadDetailsLink);

    isLoading = true;
    errorMessage = _defaultErrorMessage;

    _leadsRepository.getLeadDetails(leadDetailsLink).then((result) {
      isLoading = false;
      if (result.hasSucceeded) {
        offerDetails = result.data;
      } else if (result.hasFailed) {
        errorMessage = result.error;
      }
    });
  }

  @action
  void openWhatsApp() {
    final phone = offerDetails.getAuthorPhone();

    AppLauncherHelper.launchWhatsApp(phone.number).then((launched) {
      errorLaunchingWhatsApp = !launched;
    });
  }

  void callClient() {
    // assuming that we always have at least one phone in the list
    final phone = offerDetails.getAuthorPhone();

    AppLauncherHelper.launchCallApp(phone.number);
  }
}
