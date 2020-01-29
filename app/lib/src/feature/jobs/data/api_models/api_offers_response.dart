/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:json_annotation/json_annotation.dart';

part 'api_offers_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ApiOffersResponse {
  List<ApiOffer> offers;
  @JsonKey(name: '_links')
  Links links;

  ApiOffersResponse({
    this.offers,
    this.links,
  });

  factory ApiOffersResponse.fromJson(Map<String, dynamic> json) => 
      _$ApiOffersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiOffersResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Links {
  Self self;

  Links({
    this.self,
  });

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}

@JsonSerializable()
class Self {
  String href;

  Self({this.href});

  factory Self.fromJson(Map<String, dynamic> json) => _$SelfFromJson(json);

  Map<String, dynamic> toJson() => _$SelfToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ApiOffer {
  String state;
  @JsonKey(name: '_embedded')
  OfferEmbedded embedded;
  @JsonKey(name: '_links')
  Links links;

  ApiOffer({
    this.state,
    this.embedded,
    this.links,
  });

  factory ApiOffer.fromJson(Map<String, dynamic> json) => _$ApiOfferFromJson(json);

  Map<String, dynamic> toJson() => _$ApiOfferToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OfferEmbedded {
  Request request;

  OfferEmbedded({
    this.request,
  });

  factory OfferEmbedded.fromJson(Map<String, dynamic> json) => _$OfferEmbeddedFromJson(json);

  Map<String, dynamic> toJson() => _$OfferEmbeddedToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Request {
  @JsonKey(name: 'created_at')
  DateTime createdAt;
  String title;
  @JsonKey(name: '_embedded')
  RequestEmbedded embedded;

  Request({
    this.createdAt,
    this.title,
    this.embedded,
  });

  factory Request.fromJson(Map<String, dynamic> json) => _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RequestEmbedded {
  User user;
  ApiAddress address;

  RequestEmbedded({
    this.user,
    this.address,
  });

  factory RequestEmbedded.fromJson(Map<String, dynamic> json) => _$RequestEmbeddedFromJson(json);

  Map<String, dynamic> toJson() => _$RequestEmbeddedToJson(this);
}

@JsonSerializable()
class ApiAddress {
  String city;
  String neighborhood;
  String uf;

  ApiAddress({
    this.city,
    this.neighborhood,
    this.uf,
  });

  factory ApiAddress.fromJson(Map<String, dynamic> json) => _$ApiAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ApiAddressToJson(this);
}

@JsonSerializable()
class User {
  String name;

  User({this.name});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
