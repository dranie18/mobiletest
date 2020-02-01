/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 1/2/2020
 */

import 'package:app/src/feature/jobs/ui/widgets/header_text.dart';
import 'package:app/src/feature/jobs/ui/widgets/padded_content.dart';
import 'package:app/src/models/info.dart';
import 'package:flutter/material.dart';

class InfoContent extends StatelessWidget {
  final List<Info> infoList;
  final Color iconColor;

  const InfoContent({
    Key key,
    @required this.iconColor,
    @required this.infoList,
  })  : assert(infoList != null),
        assert(iconColor != null),
        super(key: key);

  final _contentPadding = 16.0;


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PaddedContent(
      children: infoList.map((info) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(Icons.info, color: iconColor),
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
    );
  }
}
