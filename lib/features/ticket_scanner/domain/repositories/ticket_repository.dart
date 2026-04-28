import '../../../../core/utils/task_results.dart';
import '../entities/ticket.dart';

abstract class TicketRepository {
  /// Validates a ticket code against the remote server.
  Future<TaskResult<Ticket>> verifyTicket(String code);

  Stream<bool> get connectionStatus;
}
