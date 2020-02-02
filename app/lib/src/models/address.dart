/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:app/src/models/geolocation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'address.g.dart';

@JsonSerializable(explicitToJson: true)
class Address {
  final String city;
  final String neighborhood;
  final String uf;
  final Geolocation geolocation;

  Address({
    @required this.city,
    @required this.neighborhood,
    @required this.uf,
    this.geolocation,
  })  : assert(uf != null),
        assert(city != null),
        assert(neighborhood != null);

  String get completeAddress => '$neighborhood - $city';

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
