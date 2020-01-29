/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:dio/dio.dart';

Dio _dioInstance;

class DioBuilder {
  int sendTimeout;
  int receiveTimeout;
  String baseUrl;

  DioBuilder();

  DioBuilder setBaseUrl(String baseUrl) {
    assert(baseUrl != null);
    this.baseUrl = baseUrl;
    return this;
  }

  DioBuilder setSendTimeout(int sendTimeout) {
    assert(sendTimeout != null);
    this.sendTimeout = sendTimeout;
    return this;
  }

  DioBuilder setReceiveTimeout(int receiveTimeout) {
    assert(receiveTimeout != null);
    this.receiveTimeout = receiveTimeout;
    return this;
  }

  Dio build() {
    if (_dioInstance == null) {
      _dioInstance = Dio();
      _dioInstance.options.baseUrl = baseUrl;
      _dioInstance.options.sendTimeout = sendTimeout;
      _dioInstance.options.receiveTimeout = receiveTimeout;
    }
    return _dioInstance;
  }
}