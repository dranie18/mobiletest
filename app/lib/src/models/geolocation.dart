/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

class Geolocation {
  final double latitude;
  final double longitude;

  Geolocation([
    this.latitude = 0,
    this.longitude = 0,
  ])  : assert(latitude != null),
        assert(longitude != null);
}
