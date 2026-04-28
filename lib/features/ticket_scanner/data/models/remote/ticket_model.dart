import '../../../../../core/utils/task_results.dart';
import '../../../../events/domain/entities/value_objects.dart';
import '../../../domain/entities/ticket.dart';

class TicketModel {
  final String code;
  final String holderName;
  final String ticketType;
  final bool isValid;
  final DateTime? scannedAt;

  TicketModel({
    required this.code,
    required this.holderName,
    required this.ticketType,
    required this.isValid,
    this.scannedAt,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      code: json['code'] ?? '',
      holderName: json['holder_name'] ?? 'Unknown',
      ticketType: json['ticket_type'] ?? 'Standard',
      isValid: json['is_valid'] ?? false,
      scannedAt: json['scanned_at'] != null
          ? DateTime.parse(json['scanned_at'])
          : null,
    );
  }

  Ticket toEntity() {
    final codeResult = TicketCode.create(code);
    return Ticket(
      code: codeResult is SuccessResult<TicketCode> ? codeResult.data : null!,
      holderName: holderName,
      ticketType: ticketType,
      isValid: isValid,
      scannedAt: scannedAt,
    );
  }
}
