import '../../../../core/utils/task_results.dart';
import '../entities/ticket.dart';
import '../entities/value_objects.dart';
import '../repositories/ticket_repository.dart';

class VerifyTicketUseCase {
  final TicketRepository repository;

  VerifyTicketUseCase(this.repository);

  Future<TaskResult<Ticket>> call(String rawCode) async {
    // Validate the input using the Value Object
    final codeResult = TicketCode.create(rawCode);

    if (codeResult is ErrorResult<TicketCode>) {
      return ErrorResult(error: codeResult.error);
    }

    // Business Logic: Only proceed to repository if the code is valid
    final validCode = (codeResult as SuccessResult<TicketCode>).data;
    return await repository.verifyTicket(validCode.value);
  }
}
