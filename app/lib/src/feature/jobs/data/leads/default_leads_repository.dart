/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/leads/leads_data_source.dart';
import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/models/lead.dart';
import 'package:app/src/models/operation_result.dart';

class DefaultLeadsRepository extends LeadsRepository {
  final LeadsDataSource _remoteDataSource;

  DefaultLeadsRepository(this._remoteDataSource)
      : assert(_remoteDataSource != null);

  @override
  Future<OperationResult<List<Lead>, String>> getAllLeads() {
    // TODO: implement getAllLeads
    return _remoteDataSource.getAllLeads();
  }
}
