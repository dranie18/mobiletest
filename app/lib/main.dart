/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 27/1/2020
 */

import 'package:app/src/dependency_injection/dependency_injection.dart';
import 'package:app/src/feature/jobs/ui/jobs_page.dart';
import 'package:flutter/material.dart';

void main() {
 WidgetsFlutterBinding.ensureInitialized();

 DependencyInjection().setup();

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
        appBarTheme: AppBarTheme(
          color: Colors.blue
        )
      ),
      home: JobsPage(),
    );
  }
}