/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/feature/jobs/data/api_models/api_offers_response.dart';
import 'package:app/src/feature/jobs/data/offers/offers_data_source.dart';
import 'package:app/src/http_client/endpoints.dart';
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
  Future<OperationResult<List<Offer>, String>> getAllOffers() async {
    try {
      final response = await _dio.get(Endpoints.offers);
      final responseData = ApiOffersResponse.fromJson(response.data);
      final data = responseData.offers.map((apiOffer) {
        final address = apiOffer.embedded.request.embedded.address;
        return Offer(
          requestTitle: apiOffer.embedded.request.title,
          authorName: apiOffer.embedded.request.embedded.user.name,
          offerDetailsLink: SelfLink(apiOffer.links.self.href),
          creationDate: apiOffer.embedded.request.createdAt,
          status: OfferStatus(apiOffer.state),
          requestAddress: Address(city: address.city, neighborhood: address.neighborhood, uf: address.uf)
        );
      }).toList();

      return OperationResult.success(data);
    } on DioError catch(dioError) {
      return OperationResult.failed(dioError.message);
    }
  }

}