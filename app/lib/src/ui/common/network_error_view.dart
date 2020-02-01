/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 1/2/2020
 */

import 'package:flutter/material.dart';

class NetworkErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NetworkErrorView(this.message, {@required this.onRetry})
      :
        assert(message != null),
        assert(onRetry != null);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(color:Theme.of(context).colorScheme.onPrimary);

    return LayoutBuilder(
      builder: (_, constraints) {
        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: constraints.constrainWidth() / 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    message,
                    style: textStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                OutlineButton(
                  child: Text("Tentar Novamente", style: textStyle),
                  onPressed: () => onRetry(),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
