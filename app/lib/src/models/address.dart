/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:meta/meta.dart';

class Address {
  final String city;
  final String neighborhood;
  final String uf;

  Address({
    @required this.city,
    @required this.neighborhood,
    @required this.uf,
  })  : assert(uf != null),
        assert(city != null),
        assert(neighborhood != null);

  String get completeAddress => '$neighborhood - $city';
}
