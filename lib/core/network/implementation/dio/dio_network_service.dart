import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ticket_track/core/network/implementation/dio/dio_failure_mapper.dart';
import 'package:ticket_track/core/network/network_service.dart';
import 'package:ticket_track/core/network/src/network_request.dart';
import 'package:ticket_track/core/network/src/network_response.dart';
import 'package:ticket_track/core/utils/exception/failure_types.dart';

import 'interceptors/logging_interceptor.dart';

class DioNetworkService implements NetworkService {
  static const _tag = "DioNetworkService";

  @override
  Future<NetworkResponse> sendJsonRequest({required NetworkRequest request}) async {
    final Dio dio = Dio(BaseOptions(headers: request.headers));

    dio.interceptors.add(buildLogInterceptor());

    int requestCountTry = 0;

    while (requestCountTry <= request.retryCount) {
      bool isLastTry = requestCountTry == request.retryCount;

      try {
        Response response = await switch (request.method) {
          HttpMethod.delete => dio.deleteUri(request.uri, data: jsonEncode(request.data)),
          HttpMethod.get => dio.getUri(request.uri),
          HttpMethod.patch => dio.patchUri(request.uri, data: jsonEncode(request.data)),
          HttpMethod.post => dio.postUri(request.uri, data: jsonEncode(request.data)),
          HttpMethod.put => dio.putUri(request.uri,data: jsonEncode(request.data)),
        };

        int? statusCode = response.statusCode;
        if (statusCode == null) {
          return FailureNetworkResponse(message: "Failed to get status code", data: response.data);
        }

        return SuccessNetworkResponse(statusCode: statusCode, data: response.data);
      } on SocketException catch (e, trace) {
        return FailureNetworkResponse(
          message: e.message,
          stackTrace: trace,
          failType: FailureType.network,
        );
      } on DioException catch (e, trace) {
        if (isLastTry || !e.type.shouldRetry) {
          return FailureNetworkResponse(
            statusCode: e.response?.statusCode,
            message: e.message ?? e.error.toString(),
            stackTrace: trace,
            failType: e.type.failureType,
            data: e.response?.data,
          );
        }

        requestCountTry++;
      } catch (e, trace) {
        return FailureNetworkResponse(message: e.toString(), stackTrace: trace);
      }
    }

    return FailureNetworkResponse(message: "Failed to send request");
  }
}