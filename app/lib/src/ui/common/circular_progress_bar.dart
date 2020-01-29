/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 29/1/2020
 */

import 'package:flutter/material.dart';

class CircularProgressbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(Colors.white),
    );
  }
}
