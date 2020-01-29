/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/feature/jobs/ui/available_leads_tab.dart';
import 'package:app/src/feature/jobs/ui/available_offers_tab.dart';
import 'package:flutter/material.dart';

class JobsPage extends StatefulWidget {
  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage>
    with SingleTickerProviderStateMixin {

  TabController _tabController;

  final _tabTitles = <String>[];

  void _populateTabTitles() {
    _tabTitles.add('Disponível');
    _tabTitles.add('Aceitos');
  }

  @override
  void initState() {
    super.initState();
    _populateTabTitles();

    _tabController = TabController(
      vsync: this,
      length: _tabTitles.length,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(color: Colors.white, width: 270,),
      appBar: AppBar(
        title: Text('Pedidos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabTitles.map((title) => Tab(text: title)).toList()
        )
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          AvailableOffersTab(),
          AvailableLeadsTab()
        ],
      ),
    );
  }
}
