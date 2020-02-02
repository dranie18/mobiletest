/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 27/1/2020
 */

import 'package:app/src/data/app_database.dart';
import 'package:app/src/dependency_injection/dependency_injection.dart';
import 'package:app/src/feature/jobs/ui/jobs_page.dart';
import 'package:app/src/http_client/dio_builder.dart';
import 'package:flutter/material.dart';

void main() {
 WidgetsFlutterBinding.ensureInitialized();

 final database = AppDatabase.getInstance();

 final dio = DioBuilder()
     .setReceiveTimeout(30000)
     .setSendTimeout(30000)
     .build();

 DependencyInjection(
   dio: dio,
   database: database,
 ).setup();

 runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GetNinjas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue,
        cardColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Colors.blue
        )
      ),
      home: JobsPage(),
    );
  }
}