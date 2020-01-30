/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/api_models/api_offers_response.dart';
import 'package:app/src/feature/jobs/data/offers/offers_data_source.dart';
import 'package:app/src/feature/jobs/data/offers/offers_result.dart';
import 'package:app/src/http_client/api_endpoints.dart';
import 'package:app/src/models/address.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/offer_status.dart';
import 'package:app/src/models/operation_result.dart';
import 'package:app/src/models/self_link.dart';
import 'package:dio/dio.dart';

class OffersService implements OffersDataSource {
  final Dio _dio;

  OffersService(this._dio) : assert(_dio != null);

  @override
  Future<OperationResult<OffersResult, String>> getAllOffers() async {
    try {
      final response = await _dio.get(ApiEndpoints.offers);
      final data = _parseOffersResult(response.data);
      return OperationResult.success(data);
    } on DioError catch(dioError) {
      return OperationResult.failed(dioError.message);
    }
  }

  @override
  Future<OperationResult<OffersResult, String>> refreshOffers(SelfLink refreshLink) async {
    try {
      final response = await _dio.get(refreshLink.href);
      final data = _parseOffersResult(response.data);
      return OperationResult.success(data);
    } on DioError catch(dioError) {
      return OperationResult.failed(dioError.message);
    }
  }

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

}