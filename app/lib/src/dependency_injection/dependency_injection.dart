/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/data/app_database.dart';
import 'package:app/src/data/data_access_objects/offers_dao.dart';
import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/leads/default_leads_repository.dart';
import 'package:app/src/feature/jobs/data/leads/leads_data_source.dart';
import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/feature/jobs/data/leads/leads_service.dart';
import 'package:app/src/feature/jobs/data/offers/default_offers_respository.dart';
import 'package:app/src/feature/jobs/data/offers/offers_data_source.dart';
import 'package:app/src/feature/jobs/data/offers/offers_local_data_source.dart';
import 'package:app/src/feature/jobs/data/offers/offers_respository.dart';
import 'package:app/src/feature/jobs/data/offers/offers_service.dart';
import 'package:app/src/http_client/dio_builder.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

class DependencyInjection {
  final Dio dio;
  final AppDatabase database;

  DependencyInjection({
    @required this.database,
    @required this.dio,
  })  : assert(database != null),
        assert(dio != null);

  void setup() {
    _registerServices();
    _registerDaos();
    _registerLocalDataSources();
    _registerRepositories();
  }

  void _registerServices() {
    injector.registerSingleton<OffersDataSource>(OffersService(dio));
    injector.registerSingleton<LeadsDataSource>(LeadsService(dio));
  }

  void _registerDaos() {
    injector.registerSingleton<OffersDao>(database.offersDao);
  }

  void _registerLocalDataSources() {
    injector.registerSingleton<OffersLocalDataSource>(
        OffersLocalDataSource(injector.get()));
  }

  void _registerRepositories() {
    injector.registerSingleton<OffersRepository>(
        DefaultOffersRepository(
          remoteDataSource: injector.get<OffersDataSource>(),
          localDataSource: injector.get<OffersLocalDataSource>(),
        )
    );
    injector.registerSingleton<LeadsRepository>(
        DefaultLeadsRepository(injector.get()));
  }
}
