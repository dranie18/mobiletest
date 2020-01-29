/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/leads/default_leads_repository.dart';
import 'package:app/src/feature/jobs/data/leads/leads_data_source.dart';
import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/feature/jobs/data/leads/leads_service.dart';
import 'package:app/src/feature/jobs/data/offers/default_offers_respository.dart';
import 'package:app/src/feature/jobs/data/offers/offers_data_source.dart';
import 'package:app/src/feature/jobs/data/offers/offers_respository.dart';
import 'package:app/src/feature/jobs/data/offers/offers_service.dart';
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
    injector.registerSingleton<LeadsDataSource>(LeadsService(_dio));
  }

  void _registerRepositories() {
    injector.registerSingleton<OffersRepository>(
        DefaultOffersRepository(injector.get()));
    injector.registerSingleton<LeadsRepository>(
        DefaultLeadsRepository(injector.get()));
  }
}
