/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/leads/leads_repository.dart';
import 'package:app/src/feature/jobs/ui/widgets/header_text.dart';
import 'package:app/src/feature/jobs/view_models/lead_details_view_model.dart';
import 'package:app/src/models/lead_details.dart';
import 'package:app/src/models/self_link.dart';
import 'package:app/src/ui/common/circular_progress_bar.dart';
import 'package:app/src/ui/common/dashed_divider.dart';
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

  @override
  void initState() {
    super.initState();
    _registerListeners();
    if (widget.leadDetails != null) {
      _detailsViewModel.setLeadDetails(widget.leadDetails);
    } else {
      _detailsViewModel.loadLeadDetails(widget.leadDetailsLink);
    }
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
              return Text("Falha ao carregar os detalhes da oferta!");
            if (_detailsViewModel.hasData)
              return SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(16))
                  ),
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: _DetailsContent(_detailsViewModel.offerDetails),
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
  final LeadDetails offerDetails;

  const _DetailsContent(this.offerDetails)
      : assert(offerDetails != null);

  final _contentPadding = 16.0;

  String _getDistanceInfo() {
    return (StringBuffer('a')
      ..write(' ')
      ..write(offerDetails.distance.toString())
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
          child: Text(offerDetails.requestTitle,
              style: textTheme.title.copyWith(
                  color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        const DashedDivider(padding: 16),
        _ContentArea(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: HeaderText(offerDetails.authorName),
            ),
            HeaderText(offerDetails.requestAddress.completeAddress),
            Text(_getDistanceInfo(), style: textTheme.caption,)
          ],
        ),
        const DashedDivider(padding: 16),
        _ContentArea(
          children: offerDetails.infoList.map((info) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.info, color: Colors.green),
                    Padding(
                      padding: EdgeInsets.only(left: _contentPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: _contentPadding),
                            child: HeaderText(info.label),
                          ),
                          if (info.hasStringValue)
                            Text(info.getValueAsString(), style: textTheme.caption,),
                          if (info.hasListValue)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: info.getValueAsList().map((value) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(value, style: textTheme.caption),
                                );
                              }).toList(),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8,)
              ],
            );
          }).toList(),
        ),
        _ContactArea(offerDetails: offerDetails),
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

class _ContactArea extends StatelessWidget {
  final LeadDetails offerDetails;

  const _ContactArea({this.offerDetails}) : assert(offerDetails != null);

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.black;
    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.title.copyWith(fontSize: 16, color: textColor);

    return Container(
      color: Colors.green,
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      constraints: BoxConstraints(
          minHeight: 50,
          minWidth: double.infinity
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Contacto do Cliente', style: textTheme.title.copyWith(
              color: textColor
          ),),
          const SizedBox(height: 16,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: offerDetails.authorPhones.map((phone) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.phone, color: textColor),
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Text(phone.number, style: textStyle),
                    )
                  ],
                ),
              );
            }).toList(),
          ),
          Row(
            children: <Widget>[
              Icon(Icons.mail, color: textColor),
              Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(offerDetails.authorEmail, style: textStyle)
              )
            ],
          )
          ,
        ],
      ),
    );
  }
}

class _ContentArea extends StatelessWidget {
  final double padding;
  final List<Widget> children;

  const _ContentArea({Key key,
    this.padding = 16,
    @required this.children,
  })
      : assert(padding != null),
        assert(children != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children),
    );
  }
}
