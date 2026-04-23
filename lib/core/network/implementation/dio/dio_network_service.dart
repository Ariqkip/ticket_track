import 'package:ticket_track/core/network/network_service.dart';
import 'package:ticket_track/core/network/src/network_request.dart';
import 'package:ticket_track/core/network/src/network_response.dart';

class DioNetworkService implements NetworkService{

  @override
  Future<NetworkResponse> sendJsonRequest({required NetworkRequest request}) async {

    throw UnimplementedError();
  }

}