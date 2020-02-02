/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

import 'package:json_annotation/json_annotation.dart';

part 'geolocation.g.dart';

@JsonSerializable()
class Geolocation {
  final double latitude;
  final double longitude;

  Geolocation([
    this.latitude = 0,
    this.longitude = 0,
  ])  : assert(latitude != null),
        assert(longitude != null);


  factory Geolocation.fromJson(Map<String, dynamic> json) => _$GeolocationFromJson(json);

  Map<String, dynamic> toJson() => _$GeolocationToJson(this);
}
