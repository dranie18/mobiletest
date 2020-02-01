/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

import 'package:app/src/dependency_injection/injector.dart';
import 'package:app/src/feature/jobs/data/offers/offers_respository.dart';
import 'package:app/src/feature/jobs/ui/lead_details_page.dart';
import 'package:app/src/feature/jobs/ui/widgets/contacts_area.dart';
import 'package:app/src/feature/jobs/ui/widgets/header_text.dart';
import 'package:app/src/feature/jobs/ui/widgets/info_content.dart';
import 'package:app/src/feature/jobs/ui/widgets/padded_content.dart';
import 'package:app/src/feature/jobs/view_models/offer_details_view_model.dart';
import 'package:app/src/models/offer.dart';
import 'package:app/src/models/offer_details.dart';
import 'package:app/src/ui/common/circular_progress_bar.dart';
import 'package:app/src/ui/common/dashed_divider.dart';
import 'package:app/src/ui/common/network_error_view.dart';
import 'package:app/src/ui/common/progress_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

final _scaffoldState = GlobalKey<ScaffoldState>();

class OfferDetailsPage extends StatefulWidget {
  final Offer offer;

  const OfferDetailsPage({@required this.offer}) : assert(offer != null);

  @override
  _OfferDetailsPageState createState() => _OfferDetailsPageState();
}

class _OfferDetailsPageState extends State<OfferDetailsPage> {
  final _detailsViewModel =
      OfferDetailsViewModel(injector.get<OffersRepository>());

  AcceptOfferViewModel get _acceptOfferViewModel =>
      _detailsViewModel.acceptOfferViewModel;
  DenyOfferViewModel get _denyOfferViewModel =>
      _detailsViewModel.denyOfferViewModel;

  final List<ReactionDisposer> _disposers = [];

  final _answerButtonsHeight = 50.0;

  void _showSnackBar(String message) {
    _scaffoldState.currentState..removeCurrentSnackBar();
    _scaffoldState.currentState.showSnackBar(
      SnackBar(content: Text(message),)
    );
  }

  void _loadOfferDetails() {
    _detailsViewModel.loadOfferDetails(widget.offer);
  }

  @override
  void initState() {
    super.initState();
    _loadOfferDetails();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _disposers.add(reaction((_) => _acceptOfferViewModel.hasError, (hasError) {
      if (hasError)
        _showSnackBar(_acceptOfferViewModel.errorMessage);
    }));
    _disposers.add(reaction((_) => _denyOfferViewModel.hasError, (hasError) {
      if (hasError)
        _showSnackBar(_denyOfferViewModel.errorMessage);
    }));
    _disposers.add(when((_) => _acceptOfferViewModel.isOfferAccepted, () {
      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => LeadDetailsPage(leadDetails: _acceptOfferViewModel.acceptedOffer,)
      ));
    }));
    _disposers.add(when((_) => _denyOfferViewModel.isOfferDenied, () {
      // When a offer is denied we are just navigating back
      Navigator.pop(context);
    }));
  }

  @override
  void dispose() {
    _disposers.forEach((disposer) => disposer());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final answerButtonsStyle = textTheme.title;

    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        title: Text('Oferta'),
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
                "Falha ao carregar os detalhes da oferta!",
                onRetry: () => _loadOfferDetails(),
              );
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
      bottomNavigationBar: Observer(
        builder: (context) {
          final hasData = _detailsViewModel.hasData;
          final isLoadingData = _detailsViewModel.isLoading;
          final isAcceptingOffer = _acceptOfferViewModel.isLoading;
          final isDenyingOffer = _denyOfferViewModel.isLoading;

          return Visibility(
            visible: !isLoadingData && hasData,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ProgressButton(
                    Text('Recusar'.toUpperCase(), style: answerButtonsStyle),
                    height: _answerButtonsHeight,
                    isLoading: isDenyingOffer,
                    disable: isAcceptingOffer,
                    color: Colors.grey,
                    onPressed: () => _detailsViewModel.denyOffer(),
                ),
                ),
                Expanded(
                  child: ProgressButton(
                    Text('Aceitar'.toUpperCase(), style: answerButtonsStyle),
                    height: _answerButtonsHeight,
                    color: Colors.green,
                    isLoading: isAcceptingOffer,
                    disable: isDenyingOffer,
                    onPressed: () => _detailsViewModel.acceptOffer(),
                ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final OfferDetails offerDetails;

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
        PaddedContent(
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
        InfoContent(
          iconColor: Theme.of(context).scaffoldBackgroundColor,
          infoList: offerDetails.infoList,
        ),
        ContactArea(
          mailIcon: Icons.lock,
          phoneIcon: Icons.lock,
          textsColor: Colors.white.withOpacity(.7),
          backgroundColor: Colors.lightBlueAccent,
          phones: offerDetails.authorPhones,
          email: offerDetails.authorEmail,
        ),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.fromLTRB(_contentPadding, 0, _contentPadding, _contentPadding),
            child: Text('Aceite o pedido para destravar o contacto!',
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
