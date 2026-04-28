import 'package:equatable/equatable.dart';
import '../../../../core/utils/task_results.dart';

class TicketCode extends Equatable {
  final String value;

  const TicketCode._(this.value);

  static TaskResult<TicketCode> create(String input) {
    final sanitized = input.trim();

    if (sanitized.isEmpty) {
      return ErrorResult(error: "QR code cannot be empty");
    }

    if (sanitized.length < 5) {
      return ErrorResult(error: "QR code too short");
    }

    if (!RegExp(r'^[a-zA-Z0-9\-\_]+$').hasMatch(sanitized)) {
      return ErrorResult(error: "QR code contains invalid characters");
    }

    return SuccessResult(data: TicketCode._(sanitized));
  }

  @override
  List<Object?> get props => [value];
}