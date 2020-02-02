/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 2/2/2020
 */

class NotImplementedException implements Exception {
  final String message;

  NotImplementedException(this.message);
}

final notImplementedException =
    NotImplementedException('This function must not be implemented in this class!');
