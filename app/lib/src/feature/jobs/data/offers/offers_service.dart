/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/api_models/api_lead_details_response.dart';
import 'package:app/src/feature/jobs/data/api_models/api_offer_details_response.dart';
import 'package:app/src/feature/jobs/data/api_models/api_offers_response.dart';
import 'package:app/src/feature/jobs/data/offers/offers_data_source.dart';
import 'package:app/src/feature/jobs/data/offers/offers_result.dart';
import 'package:app/src/http_client/api_endpoints.dart';
import 'package:app/src/http_client/dio_error_utils.dart';
import 'package:app/src/models/address.dart';
import 'package:app/src/models/geolocation.dart';
import 'package:app/src/models/info.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/offer_details.dart';
import 'package:app/src/models/offer_status.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/phone.dart';
import 'package:app/src/models/self_link.dart';
import 'package:dio/dio.dart';

class OffersService implements OffersDataSource {
  final Dio _dio;

  OffersService(this._dio) : assert(_dio != null);

  OffersResult _parseOffersResult(Map<String, dynamic> json) {
    assert(json != null);

    final responseData = ApiOffersResponse.fromJson(json);
    final data = responseData.offers.map((apiOffer) {
      final address = apiOffer.embedded.request.embedded.address;
      return Offer(
          requestTitle: apiOffer.embedded.request.title,
          authorName: apiOffer.embedded.request.embedded.user.name,
          detailsLink: SelfLink(apiOffer.links.self.href),
          creationDate: apiOffer.embedded.request.createdAt,
          status: OfferStatus(apiOffer.state),
          requestAddress: Address(city: address.city, neighborhood: address.neighborhood, uf: address.uf)
      );
    }).toList();
    return OffersResult(data, SelfLink(responseData.links.self.href));
  }

  OfferDetails _parseOfferDetails(Map<String, dynamic> json) {
    final data = ApiOfferDetailsResponse.fromJson(json);
    final phones = data.embedded.user.embedded.phones.map((e) => Phone(e.number)).toList();
    final info = data.embedded.info.map((e) => Info(e.label, e.value)).toList();
    final _address = data.embedded.address;
    final address = Address(
      uf: _address.uf,
      city: _address.city,
      neighborhood: _address.neighborhood,
      geolocation: Geolocation(_address.geolocation.latitude, _address.geolocation.longitude)
    );

    return OfferDetails(
      leadPrice: data.leadPrice,
      distance: data.distance,
      authorEmail: data.embedded.user.email,
      infoList: info,
      requestTitle: data.title,
      authorPhones: phones,
      requestAddress: address,
      authorName: data.embedded.user.name,
      acceptOfferLink: SelfLink(data.links.accept.href),
      rejectOfferLink: SelfLink(data.links.reject.href),
    );
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
  Future<OperationResult<OffersResult, String>> getAllOffers() async {
    try {
      final entryPointResponse = await _dio.get(ApiEndpoints.entryPoint);
      final offersUrl = entryPointResponse.data['_links']['offers']['href'];
      final response = await _dio.get(offersUrl);
      final data = _parseOffersResult(response.data);
      return OperationResult.success(data);
    } on DioError catch(dioError) {
      String message = dioError.message;
      if (DioErrorUtils.isNetworkError(dioError)) {
        message = 'Falha de conexão. Verifique sua internet.';
      }
      return OperationResult.failed(message);
    }
  }

  @override
  Future<OperationResult<OffersResult, String>> refreshOffers(SelfLink refreshLink) async {
    try {
      final response = await _dio.get(refreshLink.href);
      final data = _parseOffersResult(response.data);
      return OperationResult.success(data);
    } on DioError catch(dioError) {
      String message = dioError.message;
      if (DioErrorUtils.isNetworkError(dioError)) {
        message = 'Falha de conexão. Verifique sua internet.';
      }
      return OperationResult.failed(message);
    }
  }

  @override
  Future<OperationResult<OfferDetails, String>> getOfferDetails(SelfLink offerDetailsLink) async {
    try {
      final response = await _dio.get(offerDetailsLink.href);
      final data = _parseOfferDetails(response.data);
      return OperationResult.success(data);
    } on DioError catch(dioError) {
      String message = dioError.message;
      if (DioErrorUtils.isNetworkError(dioError)) {
        message = 'Falha de conexão. Verifique sua internet.';
      }
      return OperationResult.failed(message);
    }
  }

  @override
  Future<OperationResult<LeadDetails, String>> acceptOffer(SelfLink acceptOfferLink) async {
    try {
      final response = await _dio.get(acceptOfferLink.href);
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

  @override
  Future<OperationResult<OffersResult, String>> denyOffer(SelfLink denyOfferLink) async {
    try {
      final response = await _dio.get(denyOfferLink.href);
      final data = _parseOffersResult(response.data);
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