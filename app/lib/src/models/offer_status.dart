/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

class OfferStatus {
  static final _readStatus = 'read';
  static final _unreadStatus = 'unread';
  static final _statuses = [_readStatus, _unreadStatus];

  final String status;

  OfferStatus(this.status)
      : assert(status != null),
        assert(_statuses.contains(status));

  bool get wasRead => status == _readStatus;
}
