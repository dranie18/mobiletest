/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/api_models/api_leads_response.dart';
import 'package:app/src/feature/jobs/data/leads/leads_data_source.dart';
import 'package:app/src/http_client/api_endpoints.dart';
import 'package:app/src/models/address.dart';
import 'package:app/src/models/lead.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';
import 'package:dio/dio.dart';

class LeadsService implements LeadsDataSource {
  final Dio _dio;

  LeadsService(this._dio) : assert(_dio != null);

  @override
  Future<OperationResult<List<Lead>, String>> getAllLeads() async {
    try {
      final response = await _dio.get(ApiEndpoints.leads);
      final responseData = ApiLeadsResponse.fromJson(response.data);
      final data = responseData.leads.map((apiOffer) {
        final leadEmbedded = apiOffer.embedded;
        final address = leadEmbedded.address;
        return Lead(
            requestTitle: leadEmbedded.request.title,
            creationDate: apiOffer.createdAt,
            offerDetailsLink: SelfLink(apiOffer.links.self.href),
            authorName: leadEmbedded.user.name,
            authorEmail: leadEmbedded.user?.email ?? '',
            authorCellphone: leadEmbedded.user?.cellphone ?? '',
            requestAddress: Address(city: address.city, neighborhood: address.neighborhood, uf: address.uf)
        );
      }).toList();
      return OperationResult.success(data);
    } on DioError catch (e) {
      return OperationResult.failed(e.message);
    }
  }
}
