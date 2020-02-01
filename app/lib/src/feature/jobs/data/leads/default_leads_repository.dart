/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/leads/leads_data_source.dart';
import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/models/lead.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';

class DefaultLeadsRepository extends LeadsRepository {
  final LeadsDataSource _remoteDataSource;

  DefaultLeadsRepository(this._remoteDataSource)
      : assert(_remoteDataSource != null);

  SelfLink refreshLeadsLink;

  @override
  Future<OperationResult<List<Lead>, String>> getAllLeads()  async {
    final result = await _remoteDataSource.getAllLeads();
    if (result.hasSucceeded) {
      refreshLeadsLink = result.data.refreshLink;
      return OperationResult.success(result.data.offers);
    }
    return OperationResult.failed(result.error);
  }

  @override
  Future<OperationResult<List<Lead>, String>> refreshLeads() async {
    ArgumentError.checkNotNull(refreshLeadsLink, 'refreshLeadsLink');
    final result = await _remoteDataSource.refreshLeads(refreshLeadsLink);
    if (result.hasSucceeded) {
      refreshLeadsLink = result.data.refreshLink;
      return OperationResult.success(result.data.offers);
    }
    return OperationResult.failed(result.error);
  }

  @override
  Future<OperationResult<LeadDetails, String>> getLeadDetails(SelfLink leadDetailsLink) {
    return _remoteDataSource.getLeadDetails(leadDetailsLink);
  }
}
