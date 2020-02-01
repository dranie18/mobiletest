/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 1/2/2020
 */

import 'package:app/src/models/phone.dart';
import 'package:flutter/material.dart';

class ContactArea extends StatelessWidget {
  final List<Phone> phones;
  final String email;
  final Color backgroundColor;
  final Color textsColor;
  final IconData phoneIcon;
  final IconData mailIcon;

  const ContactArea({
    @required this.phones,
    @required this.email,
    @required this.textsColor,
    @required this.backgroundColor,
    @required this.phoneIcon,
    @required this.mailIcon,
  }) : assert(phones != null),
      assert(email != null),
      assert(textsColor != null),
      assert(phoneIcon != null),
      assert(mailIcon != null),
      assert(backgroundColor != null);

  @override
  Widget build(BuildContext context) {
    final textColor = textsColor;
    final textTheme = Theme.of(context).textTheme;
    final textStyle = textTheme.title.copyWith(fontSize: 16, color: textColor);

    return Container(
      color: backgroundColor,
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
            children: phones.map((phone) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: <Widget>[
                    Icon(phoneIcon, color: textColor),
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
              Icon(mailIcon, color: textColor),
              Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(email, style: textStyle)
              )
            ],
          )
          ,
        ],
      ),
    );
  }
}
