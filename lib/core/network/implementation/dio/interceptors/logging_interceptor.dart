import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

LogInterceptor buildLogInterceptor() {
  return LogInterceptor(
    request: true,
    requestHeader: kDebugMode,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  );
}