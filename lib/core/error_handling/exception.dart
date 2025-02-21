import 'dart:developer';

import 'package:leanware_test/core/error_handling/failure.dart';
import 'package:dio/dio.dart';

class ExceptionFailure extends Failure {
  final Exception? error;
  @override
  final String message;
  ExceptionFailure._({
    required this.message,
    this.error,
  });
  factory ExceptionFailure.decode(Exception? error) {
    log(error.toString(), name: 'FAILURE[EXCEPTION]');
    return ExceptionFailure._(
      error: error,
      message: error.toString(),
    );
  }
}

class DioFailure extends Failure {
  final int? statusCode;
  final Map<String, dynamic>? data;
  final DioException? error;
  @override
  final String message;
  DioFailure._({
    required this.message,
    this.statusCode,
    this.data,
    this.error,
  });
  factory DioFailure.decode(
    DioException? error,
  ) {
    log(error.toString(), name: 'FAILURE[DIO]');
    log((error?.response?.statusCode).toString(),
        name: 'FAILURE[DIO][STATUSCODE]');
    log((error?.message).toString(), name: 'FAILURE[DIO][MESSAGE]');
    log((error?.response?.data).toString(), name: 'FAILURE[DIO][DATA]');
    return DioFailure._(
      error: error,
      statusCode: error?.response?.statusCode,
      message: error?.message ?? '',
      data: error?.response?.data,
    );
  }
}

class RoomException implements Exception {
  final String message;

  RoomException(this.message);

  @override
  String toString() => message;
}
