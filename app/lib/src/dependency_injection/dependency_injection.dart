/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/default_offers_respository.dart';
import 'package:app/src/feature/jobs/data/offers_data_source.dart';
import 'package:app/src/feature/jobs/data/offers_respository.dart';
import 'package:app/src/feature/jobs/data/offers_service.dart';
import 'package:app/src/http_client/dio_builder.dart';
import 'package:app/src/http_client/endpoints.dart';
import 'package:dio/dio.dart';

class DependencyInjection {
  Dio _dio;

  void setup() {
    _setupDio();
    _registerServices();
    _registerRepositories();
  }

  void _setupDio() {
    if (_dio == null) {
      _dio = DioBuilder()
          .setBaseUrl(Endpoints.entryPoint)
          .setReceiveTimeout(30000)
          .setSendTimeout(30000)
          .build();
    }
  }

  void _registerServices() {
    injector.registerSingleton<OffersDataSource>(OffersService(_dio));
  }

  void _registerRepositories() {
    injector.registerSingleton<OffersRepository>(
        DefaultOffersRepository(injector.get()));
  }
}
