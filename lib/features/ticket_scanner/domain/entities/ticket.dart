import 'package:equatable/equatable.dart';

import '../../../events/domain/entities/value_objects.dart';

class Ticket extends Equatable {
  final TicketCode code;
  final String holderName;
  final String ticketType;
  final bool isValid;
  final DateTime? scannedAt;

  const Ticket({
    required this.code,
    required this.holderName,
    required this.ticketType,
    required this.isValid,
    this.scannedAt,
  });

  @override
  List<Object?> get props => [code, holderName, ticketType, isValid, scannedAt];
}
