import 'package:ticket_track/core/network/src/network_request.dart';
import 'package:ticket_track/core/network/src/network_response.dart';

abstract class NetworkService {
  Future<NetworkResponse> sendJsonRequest({required NetworkRequest request});
}