/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:json_annotation/json_annotation.dart';

part 'api_leads_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ApiLeadsResponse {
  List<ApiOffer> leads;
  @JsonKey(name: '_links')
  Links links;

  ApiLeadsResponse({
    this.leads,
    this.links,
  });

  factory ApiLeadsResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiLeadsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiLeadsResponseToJson(this);
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
  @JsonKey(name: '_embedded')
  Embedded embedded;
  @JsonKey(name: '_links')
  Links links;
  @JsonKey(name: 'created_at')
  DateTime createdAt;

  ApiOffer({
    this.embedded,
    this.links,
    this.createdAt
  });

  factory ApiOffer.fromJson(Map<String, dynamic> json) => _$ApiOfferFromJson(json);

  Map<String, dynamic> toJson() => _$ApiOfferToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Embedded {
  User user;
  Request request;
  ApiAddress address;

  Embedded({
    this.request,
    this.user,
    this.address
  });

  factory Embedded.fromJson(Map<String, dynamic> json) => _$EmbeddedFromJson(json);

  Map<String, dynamic> toJson() => _$EmbeddedToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Request {
  String title;

  Request({
    this.title,
  });

  factory Request.fromJson(Map<String, dynamic> json) => _$RequestFromJson(json);

  Map<String, dynamic> toJson() => _$RequestToJson(this);
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
  String email;
  String cellphone;

  User({this.name, this.email, this.cellphone});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
