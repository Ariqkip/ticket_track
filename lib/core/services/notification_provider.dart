import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ValidationStatus {
  success,
  duplicate,
  invalid,
  expired,
  error,
  offline
}

class NotificationState {
  final String title;
  final String message;
  final String? holderName;
  final String? ticketType;
  final ValidationStatus status;
  final bool isHeld;

  NotificationState({
    required this.title,
    required this.message,
    required this.status,
    this.holderName,
    this.ticketType,
    this.isHeld = false,
  });
}

class NotificationNotifier extends StateNotifier<NotificationState?> {
  NotificationNotifier() : super(null);
  Timer? _dismissTimer;

  void emit({
    required String title,
    required String message,
    required ValidationStatus status,
    String? holderName,
    String? ticketType,
  }) {
    _dismissTimer?.cancel();

    // Trigger Multi-Sensory Feedback based on status
    _triggerHaptics(status);

    state = NotificationState(
      title: title,
      message: message,
      status: status,
      holderName: holderName,
      ticketType: ticketType,
    );

    _startTimer();
  }

  void _startTimer() {
    _dismissTimer = Timer(const Duration(milliseconds: 1500), () {
      if (state != null && !state!.isHeld) state = null;
    });
  }

  void _triggerHaptics(ValidationStatus status) {
    switch (status) {
      case ValidationStatus.success:
        HapticFeedback.heavyImpact();
      case ValidationStatus.duplicate:
        HapticFeedback.vibrate();
      case ValidationStatus.invalid:
      case ValidationStatus.expired:
      case ValidationStatus.error:
        HapticFeedback.heavyImpact();
      case ValidationStatus.offline:
        HapticFeedback.mediumImpact();
    }
  }

  void hold() {
    if (state == null) return;
    _dismissTimer?.cancel();
    state = NotificationState(
      title: state!.title,
      message: state!.message,
      status: state!.status,
      holderName: state!.holderName,
      ticketType: state!.ticketType,
      isHeld: true,
    );
  }

  void release() {
    state = null;
  }
}

final notificationProvider = StateNotifierProvider<NotificationNotifier, NotificationState?>((ref) => NotificationNotifier());