import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/events.dart';

/// Provider for the list of assigned events
final assignedEventsProvider = FutureProvider<List<Event>>((ref) async {
  // This logic replaces the 'build' method of the AsyncNotifier
  // In production, this will call ref.watch(eventRepositoryProvider).getAssignedEvents()
  await Future.delayed(const Duration(seconds: 1));

  return [
    Event(
      id: '4',
      name: 'Rooftop Tiki Party @ Serena',
      dateTime: DateTime(2026, 7, 6, 18),
      location: 'Serena • Nairobi, Kenya',
      status: EventStatus.ongoing,
      imageUrl: 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3',
    ),
    Event(
      id: '1',
      name: 'Nairobi Flutter Dev Summit 2026',
      dateTime: DateTime(2026, 6, 20, 9, 0),
      location: 'KICC • Nairobi, Kenya',
      status: EventStatus.ongoing,
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865',
    ),
    Event(
      id: '2',
      name: 'Kenya Music Fiesta',
      dateTime: DateTime(2026, 8, 15, 16, 0),
      location: 'Uhuru Gardens • Nairobi, Kenya',
      status: EventStatus.notStarted,
      imageUrl: 'https://images.unsplash.com/photo-1501386761578-eac5c94b800a',
    ),
    Event(
      id: '3',
      name: 'Startup Networking Night',
      dateTime: DateTime(2026, 4, 10, 18, 30),
      location: 'Westlands Hub • Nairobi, Kenya',
      status: EventStatus.ended,
      imageUrl: 'https://images.unsplash.com/photo-1515169067868-5387ec356754',
    ),
  ];
});

/// Notifier class for Scanner Settings
class ScannerSettingsNotifier extends StateNotifier<Map<String, bool>> {
  ScannerSettingsNotifier() : super({'sound': true, 'vibration': true});

  void toggleSound() {
    state = {...state, 'sound': !state['sound']!};
  }

  void toggleVibration() {
    state = {...state, 'vibration': !state['vibration']!};
  }
}

/// Provider for the scanner settings
final scannerSettingsProvider =
    StateNotifierProvider<ScannerSettingsNotifier, Map<String, bool>>((ref) {
      return ScannerSettingsNotifier();
    });
