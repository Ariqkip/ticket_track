

import 'package:equatable/equatable.dart';

import '../domain/entities/ticket.dart';

enum TicketScannerStatus {
  idle,
  validating,
  success,
  error,
}

class TicketScannerState extends Equatable {
  final String ticketCode;
  final bool isLoading;
  final Ticket? scannedTicket;
  final TicketScannerStatus status;
  final String? errorMessage;
  final int totalScans;

  const TicketScannerState({
    this.ticketCode = '',
    this.isLoading = false,
    this.scannedTicket,
    this.status = TicketScannerStatus.idle,
    this.errorMessage,
    this.totalScans = 0,
  });

  TicketScannerState copyWith({
    String? ticketCode,
    bool? isLoading,
    Ticket? scannedTicket,
    TicketScannerStatus? status,
    String? errorMessage,
    int? totalScans,
  }) {
    return TicketScannerState(
      ticketCode: ticketCode ?? this.ticketCode,
      isLoading: isLoading ?? this.isLoading,
      scannedTicket: scannedTicket ?? this.scannedTicket,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      totalScans: totalScans ?? this.totalScans,
    );
  }

  @override
  List<Object?> get props => [
    ticketCode,
    isLoading,
    scannedTicket,
    status,
    errorMessage,
    totalScans,
  ];
}