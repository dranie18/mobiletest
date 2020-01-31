/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/models/lead.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';

abstract class LeadsRepository {

  Future<OperationResult<List<Lead>, String>> getAllLeads();

  Future<OperationResult<List<Lead>, String>> refreshLeads();

  Future<OperationResult<LeadDetails, String>> getLeadDetails(SelfLink leadDetailsLink);
}