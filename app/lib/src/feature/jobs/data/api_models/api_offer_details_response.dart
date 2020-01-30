/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

import 'package:json_annotation/json_annotation.dart';

part 'api_offer_details_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ApiOfferDetailsResponse {
  double distance;
  @JsonKey(name: 'lead_price')
  double leadPrice;
  String title;
  @JsonKey(name: '_embedded')
  ApiOfferDetailsResponseEmbedded embedded;
  @JsonKey(name: '_links')
  Links links;

  ApiOfferDetailsResponse({
    this.distance,
    this.leadPrice,
    this.title,
    this.embedded,
    this.links,
  });

  factory ApiOfferDetailsResponse.fromJson(Map<String, dynamic> json) => _$ApiOfferDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ApiOfferDetailsResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ApiOfferDetailsResponseEmbedded {
  List<_Info> info;
  User user;
  ApiAddress address;

  ApiOfferDetailsResponseEmbedded({
    this.info,
    this.user,
    this.address,
  });

  factory ApiOfferDetailsResponseEmbedded.fromJson(Map<String, dynamic> json) => _$ApiOfferDetailsResponseEmbeddedFromJson(json);

  Map<String, dynamic> toJson() => _$ApiOfferDetailsResponseEmbeddedToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ApiAddress {
  String city;
  String neighborhood;
  String uf;
  _Geolocation geolocation;

  ApiAddress({
    this.city,
    this.neighborhood,
    this.uf,
    this.geolocation,
  });

  factory ApiAddress.fromJson(Map<String, dynamic> json) => _$ApiAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ApiAddressToJson(this);
}

@JsonSerializable()
class _Geolocation {
  double latitude;
  double longitude;

  _Geolocation({
    this.latitude,
    this.longitude,
  });

  factory _Geolocation.fromJson(Map<String, dynamic> json) => _$_GeolocationFromJson(json);

  Map<String, dynamic> toJson() => _$_GeolocationToJson(this);
}

@JsonSerializable()
class _Info {
  String label;
  dynamic value;

  _Info({
    this.label,
    this.value,
  });

  factory _Info.fromJson(Map<String, dynamic> json) => _$_InfoFromJson(json);

  Map<String, dynamic> toJson() => _$_InfoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class User {
  String name;
  String email;
  @JsonKey(name: '_embedded')
  UserEmbedded embedded;

  User({
    this.name,
    this.email,
    this.embedded,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable(explicitToJson: true)
class UserEmbedded {
  List<_Phone> phones;

  UserEmbedded({
    this.phones,
  });

  factory UserEmbedded.fromJson(Map<String, dynamic> json) => _$UserEmbeddedFromJson(json);

  Map<String, dynamic> toJson() => _$UserEmbeddedToJson(this);
}

@JsonSerializable()
class _Phone {
  String number;

  _Phone({
    this.number,
  });

  factory _Phone.fromJson(Map<String, dynamic> json) => _$_PhoneFromJson(json);

  Map<String, dynamic> toJson() => _$_PhoneToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Links {
  Accept accept;
  Accept reject;

  Links({
    this.accept,
    this.reject,
  });

  factory Links.fromJson(Map<String, dynamic> json) => _$LinksFromJson(json);

  Map<String, dynamic> toJson() => _$LinksToJson(this);
}

@JsonSerializable()
class Accept {
  String href;

  Accept({
    this.href,
  });

  factory Accept.fromJson(Map<String, dynamic> json) => _$AcceptFromJson(json);

  Map<String, dynamic> toJson() => _$AcceptToJson(this);
}
