/*
 *  Copyright 2020 GetNinjas. All rights reserved.
 *  Created by Pedro Massango on 28/1/2020
 */

import 'package:app/src/models/operation_status.dart';
import 'package:meta/meta.dart';

class OperationResult<TData, TError> {
  final TData data;
  final TError error;
  final OperationStatus status;

  OperationResult({this.data, this.error, @required this.status})
      : assert(status != null);

  bool get hasFailed => status == OperationStatus.failed;

  bool get isPending => status == OperationStatus.pending;

  bool get hasSucceeded => status == OperationStatus.succeeded;

  factory OperationResult.idle({TData data}) =>
      OperationResult(data: data, status: OperationStatus.idle);

  factory OperationResult.pending({TData data}) =>
      OperationResult(data: data, status: OperationStatus.pending);

  factory OperationResult.failed(TError error) =>
      OperationResult(error: error, status: OperationStatus.failed);

  factory OperationResult.success(TData data) =>
      OperationResult(data: data, status: OperationStatus.succeeded);
}
