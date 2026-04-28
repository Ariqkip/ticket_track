import 'package:ticket_track/core/network/network_service.dart';

import '../../../../../../core/network/src/network_request.dart';
import '../../../../../../core/network/src/network_response.dart';

abstract class TicketRemoteDataSource {
  Future<NetworkResponse> verifyTicket(String code);
}

class TicketRepositoryImpl extends TicketRemoteDataSource {
  final NetworkService _networkService;

  TicketRepositoryImpl(this._networkService);

  @override
  Future<NetworkResponse> verifyTicket(String code) async {
    final request = NetworkRequest(
      uri: Uri.parse("base_url/verify_ticket"),
      method: HttpMethod.post,
    );
    return await _networkService.sendJsonRequest(request: request);
  }
}
