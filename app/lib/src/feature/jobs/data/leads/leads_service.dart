/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/api_models/api_lead_details_response.dart';
import 'package:app/src/feature/jobs/data/api_models/api_leads_response.dart';
import 'package:app/src/feature/jobs/data/leads/leads_data_source.dart';
import 'package:app/src/feature/jobs/data/offers/offers_result.dart';
import 'package:app/src/http_client/api_endpoints.dart';
import 'package:app/src/http_client/dio_error_utils.dart';
import 'package:app/src/models/address.dart';
import 'package:app/src/models/geolocation.dart';
import 'package:app/src/models/info.dart';
import 'package:app/src/models/lead.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/phone.dart';
import 'package:app/src/models/self_link.dart';
import 'package:dio/dio.dart';

class LeadsService implements LeadsDataSource {
  final Dio _dio;

  LeadsService(this._dio) : assert(_dio != null);


  OffersResult _parseResponse(Map<String, dynamic> json) {
    final responseData = ApiLeadsResponse.fromJson(json);
    final data = responseData.leads.map((apiOffer) {
      final leadEmbedded = apiOffer.embedded;
      final address = leadEmbedded.address;
      return Lead(
          requestTitle: leadEmbedded.request.title,
          creationDate: apiOffer.createdAt,
          detailsLink: SelfLink(apiOffer.links.self.href),
          authorName: leadEmbedded.user.name,
          authorEmail: leadEmbedded.user?.email ?? '',
          authorCellphone: leadEmbedded.user?.cellphone ?? '',
          requestAddress: Address(city: address.city, neighborhood: address.neighborhood, uf: address.uf)
      );
    }).toList();
    return OffersResult(data, SelfLink(responseData.links.self.href));
  }

  LeadDetails _parseLeadDetails(Map<String, dynamic> json) {
    final data = ApiLeadDetailsResponse.fromJson(json);
    final phones = data.embedded.user.embedded.phones.map((e) => Phone(e.number)).toList();
    final info = data.embedded.info.map((e) => Info(e.label, e.value)).toList();
    final _address = data.embedded.address;
    final address = Address(
        uf: _address.uf,
        city: _address.city,
        neighborhood: _address.neighborhood,
        geolocation: Geolocation(_address.geolocation.latitude, _address.geolocation.longitude)
    );

    return LeadDetails(
      leadPrice: data.leadPrice,
      distance: data.distance,
      authorEmail: data.embedded.user.email,
      infoList: info,
      requestTitle: data.title,
      authorPhones: phones,
      requestAddress: address,
      authorName: data.embedded.user.name,
    );
  }

  @override
  Future<OperationResult<OffersResult, String>> getAllLeads() async {
    try {
      final entryPointResponse = await _dio.get(ApiEndpoints.entryPoint);
      final leadsUrl = entryPointResponse.data['_links']['leads']['href'];
      final response = await _dio.get(leadsUrl);
      final result = _parseResponse(response.data);
      return OperationResult.success(result);
    } on DioError catch (e) {
      String message = e.message;
      if (DioErrorUtils.isNetworkError(e)) {
        message = 'Falha de conexão. Verifique sua internet.';
      }
      return OperationResult.failed(message);
    }
  }

  @override
  Future<OperationResult<OffersResult, String>> refreshLeads(SelfLink link) async {
    try {
      final response = await _dio.get(link.href);
      final data = _parseResponse(response.data);
      return OperationResult.success(data);
    } on DioError catch (dioError) {
      String message = dioError.message;
      if (DioErrorUtils.isNetworkError(dioError)) {
        message = 'Falha de conexão. Verifique sua internet.';
      }
      return OperationResult.failed(message);
    }
  }

  @override
  Future<OperationResult<LeadDetails, String>> getLeadDetails(SelfLink leadDetailsLink) async {
    try {
      final response = await _dio.get(leadDetailsLink.href);
      final data = _parseLeadDetails(response.data);
      return OperationResult.success(data);
    } on DioError catch(dioError) {
      String message = dioError.message;
      if (DioErrorUtils.isNetworkError(dioError)) {
        message = 'Falha de conexão. Verifique sua internet.';
      }
      return OperationResult.failed(message);
    }
  }

}
