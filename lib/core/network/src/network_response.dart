import '../../utils/exception/failure_types.dart';

sealed class NetworkResponse {}

final class SuccessNetworkResponse extends NetworkResponse{
  final int statusCode ;
  final dynamic data;
  SuccessNetworkResponse( {required this.statusCode, this.data});
}

final class FailureNetworkResponse extends NetworkResponse{
  final int? statusCode;
  final dynamic data;
  final String? message;
  final StackTrace? stackTrace;
  final FailureType failType;
  FailureNetworkResponse({ this.statusCode, this.data, this.message="Something went wrong", this.stackTrace, this.failType=FailureType.unknown});
}
