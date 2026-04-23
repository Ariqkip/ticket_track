
# ticket_track - Event Ticket Scanner (Phase 1)

A high-performance Flutter application built with Clean Architecture and Riverpod for real-time ticket validation.

## Architecture
- **Domain Layer:** Business logic, entities, and repository interfaces.
- **Data Layer:** Repository implementations, models (Freezed), and remote data sources (Dio).
- **Presentation Layer:** Riverpod state management and UI components.

## Tech Stack
- Flutter & Riverpod
- Dio (API Communication)
- Mobile Scanner (QR Scanning)
- Freezed (Immutable Models)

## Setup
1. `flutter pub get`
2. `dart run build_runner build`