/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 1/2/2020
 */

import 'package:dio/dio.dart';

class DioErrorUtils {

  static bool isNetworkError(DioError error) {
    return error.type == DioErrorType.DEFAULT;
  }
}