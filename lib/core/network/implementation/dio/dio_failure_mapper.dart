import 'package:dio/dio.dart';
import 'package:ticket_track/lib/core/utils/exception/failure_types.dart';

extension DioFailureTypeExtension on DioExceptionType {
  FailureType get failureType => switch (this) {
        DioExceptionType.connectionTimeout => FailureType.network,
        DioExceptionType.sendTimeout => FailureType.network,
        DioExceptionType.receiveTimeout => FailureType.network,
        DioExceptionType.badCertificate => FailureType.networkServer,
        DioExceptionType.badResponse => FailureType.networkServer,
        DioExceptionType.cancel => FailureType.interrupt,
        DioExceptionType.connectionError => FailureType.network,
        DioExceptionType.unknown => FailureType.unknown,
      };
}

extension DioRetryExtension on DioExceptionType {
  bool get shouldRetry => switch (this) {
        DioExceptionType.connectionTimeout => true,
        DioExceptionType.sendTimeout => true,
        DioExceptionType.receiveTimeout => true,
        DioExceptionType.badCertificate => false,
        DioExceptionType.badResponse => false,
        DioExceptionType.cancel => true,
        DioExceptionType.connectionError => true,
        DioExceptionType.unknown => true,
      };
}
