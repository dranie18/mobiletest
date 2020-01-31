/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 31/1/2020
 */

import 'package:app/src/ui/common/circular_progress_bar.dart';
import 'package:flutter/material.dart';

class ProgressButton extends StatelessWidget {
  final Text text;
  final bool isLoading;
  final bool disable;
  final double height;
  final VoidCallback onPressed;
  final Color color;

  const ProgressButton(
    this.text, {
    Key key,
    this.isLoading,
    this.disable = false,
    this.height,
    this.color,
    @required this.onPressed,
  })  : assert(text != null),
        assert(onPressed != null),
        assert(disable != null),
        assert(color != null),
        assert(isLoading != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      color: color,
      disabledColor: color.withOpacity(.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SizedBox.fromSize(
                  size: Size.fromRadius(12), child: CircularProgressbar()),
            ),
          text
        ],
      ),
      onPressed: disable ? null : () {
        if (!isLoading)
          onPressed();
        },
    );
  }
}
