/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 1/2/2020
 */

import 'package:flutter/material.dart';

class PaddedContent extends StatelessWidget {
  final double padding;
  final List<Widget> children;

  const PaddedContent({Key key,
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