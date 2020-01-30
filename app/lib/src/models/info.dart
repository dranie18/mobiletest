/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 30/1/2020
 */

class Info {
  final String label;
  final dynamic value;

  Info(this.label, this.value);

  bool get hasStringValue => value is String;

  bool get hasListValue => value is List;

  String getValueAsString() {
    assert(value is String);
    return value as String;
  }

  List<String> getValueAsList() {
    assert(value is List);
    final valueList = value as List;
    return valueList.map((e) => e.toString()).toList();
  }
}