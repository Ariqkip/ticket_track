import 'package:equatable/equatable.dart';

import '../../../../core/utils/task_results.dart';

class TicketCode extends Equatable {
  final String value;

  // Private constructor to enforce validation through factory
  const TicketCode._(this.value);

  static TaskResult<TicketCode> create(String input) {
    final sanitized = input.trim();

    if (sanitized.isEmpty) {
      return ErrorResult(error: "QR code is empty");
    }

    if (sanitized.length < 3) {
      return ErrorResult(error: "QR code too short");
    }

    final regex = RegExp(r'^[a-zA-Z0-9\-\_]+$');
    if (!regex.hasMatch(sanitized)) {
      return ErrorResult(error: "Invalid QR format");
    }

    return SuccessResult(data: TicketCode._(sanitized));
  }

  @override
  List<Object?> get props => [value];
}
