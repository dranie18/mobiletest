/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/offers/offers_result.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';

abstract class LeadsDataSource {

  Future<OperationResult<OffersResult, String>> getAllLeads();

  Future<OperationResult<OffersResult, String>> refreshLeads(SelfLink selfLink);

  Future<OperationResult<LeadDetails, String>> getLeadDetails(SelfLink leadDetailsLink);
}