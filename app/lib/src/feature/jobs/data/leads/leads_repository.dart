/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/models/lead.dart';
import 'package:app/src/models/operation_result.dart';

abstract class LeadsRepository {

  Future<OperationResult<List<Lead>, String>> getAllLeads();

  Future<OperationResult<List<Lead>, String>> refreshLeads();
}