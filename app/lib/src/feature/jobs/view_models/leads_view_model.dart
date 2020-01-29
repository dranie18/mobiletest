/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/models/lead.dart';
import 'package:mobx/mobx.dart';

part 'leads_view_model.g.dart';

class LeadsViewModel = _LeadsViewModelBase with _$LeadsViewModel;

abstract class _LeadsViewModelBase with Store {
  final LeadsRepository _leadsRepository;

  _LeadsViewModelBase(this._leadsRepository) : assert(_leadsRepository != null);

  static final _defaultErrorMessage = '';

  @observable
  List<Lead> leads = [];

  @computed
  bool get hasData => leads.isNotEmpty;

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = _defaultErrorMessage;

  @computed
  bool get hasError => errorMessage != _defaultErrorMessage;

  @action
  void loadLeads() {
    isLoading = true;
    errorMessage = _defaultErrorMessage;

    _leadsRepository.getAllLeads().then((result) {
      isLoading = result.isPending;

      if (result.hasSucceeded) {
        leads = result.data;
      } else if (result.hasFailed) {
        errorMessage = result.error;
      }
    });
  }

}
