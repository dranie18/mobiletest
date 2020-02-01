/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/feature/jobs/ui/widgets/contacts_area.dart';
import 'package:app/src/feature/jobs/ui/widgets/header_text.dart';
import 'package:app/src/feature/jobs/ui/widgets/info_content.dart';
import 'package:app/src/feature/jobs/ui/widgets/padded_content.dart';
import 'package:app/src/feature/jobs/view_models/lead_details_view_model.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/self_link.dart';
import 'package:app/src/ui/common/circular_progress_bar.dart';
import 'package:app/src/ui/common/dashed_divider.dart';
import 'package:app/src/ui/common/network_error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

final _scaffoldState = GlobalKey<ScaffoldState>();

class LeadDetailsPage extends StatefulWidget {
  final LeadDetails leadDetails;
  final SelfLink leadDetailsLink;

  const LeadDetailsPage({
    this.leadDetails,
    this.leadDetailsLink
  }) : assert(leadDetails != null || leadDetailsLink != null);

  @override
  _LeadDetailsPageState createState() => _LeadDetailsPageState();
}

class _LeadDetailsPageState extends State<LeadDetailsPage> {
  final _detailsViewModel = LeadDetailsViewModel(injector.get<LeadsRepository>());

  final List<ReactionDisposer> disposers = [];

  final _answerButtonsHeight = 50.0;

  void _registerListeners() {
    disposers.add(reaction((_) => _detailsViewModel.errorLaunchingWhatsApp, (hasError) {
      if (hasError)
        _showSnackBar('WhatsApp não instalado');
    }));
  }

  void _showSnackBar(String message) {
    _scaffoldState.currentState.removeCurrentSnackBar();
    _scaffoldState.currentState.showSnackBar(
      SnackBar(content: Text(message))
    );
  }

  void _loadLeadDetails() {
    if (widget.leadDetails != null) {
      _detailsViewModel.setLeadDetails(widget.leadDetails);
    } else {
      _detailsViewModel.loadLeadDetails(widget.leadDetailsLink);
    }
  }

  @override
  void initState() {
    super.initState();
    _registerListeners();
    _loadLeadDetails();
  }

  @override
  void dispose() {
    disposers.forEach((disposer) => disposer());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final contactButtonsColor = Theme.of(context).scaffoldBackgroundColor;
    final answerButtonsStyle = textTheme.title.copyWith(
      color: contactButtonsColor,
      fontWeight: FontWeight.bold
    );

    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Observer(
          builder: (_) {
            final offerAuthorName = widget.leadDetails?.authorName ??
                _detailsViewModel.offerDetails?.authorName ??
                '';
            return Text(offerAuthorName);
          },
        ),
      ),
      body: Observer(
          builder: (_) {
            if (_detailsViewModel.isLoading)
              return Padding(
                padding: const EdgeInsets.only(top: 16),
                child: const Center(child: CircularProgressbar()),
              );
            if (_detailsViewModel.hasError)
              return NetworkErrorView(
                _detailsViewModel.errorMessage,
                onRetry: () => _loadLeadDetails(),
              );
            if (_detailsViewModel.hasData)
              return SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: _DetailsContent(_detailsViewModel),
                ),
              );
            return SizedBox.shrink();
          }
      ),
      bottomNavigationBar: SizedBox.fromSize(
        size: Size.fromHeight(_answerButtonsHeight),
        child: Observer(
            builder: (context) {
              final showContactsButton = (_detailsViewModel.hasData &&
                  !_detailsViewModel.isLoading);

              return Visibility(
                visible: showContactsButton,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: MaterialButton(
                          elevation: 0,
                          child: Text('Ligar'.toUpperCase(), style: answerButtonsStyle),
                          height: _answerButtonsHeight,
                          color: Colors.white,
                          onPressed: ()  => _detailsViewModel.callClient(),
                        ),
                      ),
                      VerticalDivider(
                        indent: 8,
                        endIndent: 8,
                        thickness: 1.5,
                        color: contactButtonsColor,
                      ),
                      Expanded(
                        child: MaterialButton(
                          elevation: 0,
                          child: Text('WhatsApp'.toUpperCase(), style: answerButtonsStyle),
                          height: _answerButtonsHeight,
                          color: Colors.white,
                          onPressed: () => _detailsViewModel.openWhatsApp(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final LeadDetailsViewModel detailsViewModel;

  const _DetailsContent(this.detailsViewModel)
      : assert(detailsViewModel != null);

  LeadDetails get leadDetails => detailsViewModel.offerDetails;

  final _contentPadding = 16.0;

  String _getDistanceInfo() {
    return (StringBuffer('a')
      ..write(' ')
      ..write(leadDetails.distance.toString())
      ..write(' ')
      ..write('Km')
      ..write(' ')
      ..write('de Você')
    ).toString();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Placeholder(
          fallbackWidth: double.infinity,
          fallbackHeight: 150,
        ),
        Padding(
          padding: EdgeInsets.all(_contentPadding),
          child: Text(leadDetails.requestTitle,
              style: textTheme.title.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        const DashedDivider(padding: 16),
        PaddedContent(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: HeaderText(leadDetails.authorName),
            ),
            HeaderText(leadDetails.requestAddress.completeAddress),
            Text(_getDistanceInfo(), style: textTheme.caption,)
          ],
        ),
        const DashedDivider(padding: 16),
        InfoContent(
          iconColor: Colors.green,
          infoList: leadDetails.infoList,
        ),
        ContactArea(
          mailIcon: Icons.mail,
          phoneIcon: Icons.phone,
          textsColor: Colors.black,
          backgroundColor: Colors.green,
          phones: leadDetails.authorPhones,
          email: leadDetails.authorEmail,
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.fromLTRB(_contentPadding, 0, _contentPadding, _contentPadding),
            child: Text('Fale com o cliente o quanto antes',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic
              ),),
          ),
        )
      ],
    );
  }
}