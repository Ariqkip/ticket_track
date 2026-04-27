// import 'package:riverpod_annotation/riverpod_annotation.dart';
//
//
// class ScannerState {
//   final bool isLoading;
//   final Ticket? lastTicket;
//   final String? errorMessage;
//   final int scanCount;
//
//   ScannerState({
//     this.isLoading = false,
//     this.lastTicket,
//     this.errorMessage,
//     this.scanCount = 0,
//   });
//
//   ScannerState copyWith({bool? isLoading, Ticket? lastTicket, String? errorMessage, int? scanCount}) {
//     return ScannerState(
//       isLoading: isLoading ?? this.isLoading,
//       lastTicket: lastTicket, // Intentional reset if null
//       errorMessage: errorMessage,
//       scanCount: scanCount ?? this.scanCount,
//     );
//   }
// }
//
// @riverpod
// class ScannerController extends _$ScannerController {
//   late final VerifyTicketUseCase _verifyTicketUseCase;
//
//   @override
//   ScannerState build() {
//     // Initializing usecase from a global provider (to be defined in Step 5)
//     _verifyTicketUseCase = ref.watch(verifyTicketUseCaseProvider);
//     return ScannerState();
//   }
//
//   Future<void> handleScan(String code) async {
//     if (state.isLoading) return;
//
//     state = state.copyWith(isLoading: true, errorMessage: null, lastTicket: null);
//
//     final result = await _verifyTicketUseCase(code);
//
//     state = switch (result) {
//       SuccessResult(data: final ticket) => state.copyWith(
//         isLoading: false,
//         lastTicket: ticket,
//         scanCount: state.scanCount + 1,
//       ),
//       ErrorResult(error: final msg) => state.copyWith(
//         isLoading: false,
//         errorMessage: msg,
//       ),
//     };
//   }
//
//   void resetStatus() {
//     state = state.copyWith(errorMessage: null, lastTicket: null);
//   }
// }