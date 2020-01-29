/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:intl/intl.dart';

class DateTimeUtils {

  static String date(DateTime date) {
    return DateFormat('dd - MMM').format(date);
  }
}