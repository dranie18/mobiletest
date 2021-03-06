/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final Color color;
  final double padding;

  const DashedDivider({
    Key key,
    this.padding = 0,
    this.color = Colors.grey,
  })  : assert(color != null),
        assert(padding != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final parentWidth = constraints.constrainWidth();
        final dashWidth = 5.0;
        final dashHeight = dashWidth * .3;
        final dashCount = (parentWidth / (2 * dashWidth)).floor();

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (index) {
              return SizedBox.fromSize(
                size: Size(dashWidth, dashHeight),
                child: DecoratedBox(decoration: BoxDecoration(color: color)),
              );
            }),
          ),
        );
      },
    );
  }
}
