import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/notification_provider.dart';

class GlobalNotificationOverlay extends ConsumerWidget {
  const GlobalNotificationOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(notificationProvider);
    if (status == null) return const SizedBox.shrink();

    final config = switch (status.status) {
      ValidationStatus.success => (
        color: Colors.greenAccent.shade700,
        icon: Icons.check_circle_outline_outlined,
        title: "ACCESS GRANTED",
      ),
      ValidationStatus.duplicate => (
        color: Colors.orangeAccent.shade700,
        icon: Icons.copy_rounded,
        title: "ALREADY USED",
      ),
      ValidationStatus.invalid => (
        color: Colors.redAccent.shade700,
        icon: Icons.cancel_outlined,
        title: "INVALID TICKET",
      ),
      ValidationStatus.expired => (
        color: Colors.redAccent.shade700,
        icon: Icons.timer_off_outlined,
        title: "TICKET EXPIRED",
      ),
      ValidationStatus.offline => (
        color: Colors.blueGrey.shade400,
        icon: Icons.wifi_off_outlined,
        title: "OFFLINE",
      ),
      ValidationStatus.error => (
        color: Colors.redAccent.shade700,
        icon: Icons.error_outline_rounded,
        title: "SYSTEM ERROR",
      ),
    };
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onLongPressStart: (_) => ref.read(notificationProvider.notifier).hold(),
        onLongPressEnd: (_) =>
            ref.read(notificationProvider.notifier).release(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            color: Colors.black45,
            alignment: Alignment.center,
            child:
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 48,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(color: config.color, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: config.color.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(config.icon, size: 80, color: config.color)
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .scale(duration: 400.ms, curve: Curves.easeOutBack)
                          .then()
                          .shimmer(duration: 1200.ms),
                      const SizedBox(height: 20),
                      Text(
                        config.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Divider(height: 32, color: Colors.white10),
                      if (status.holderName != null) ...[
                        Text(
                          status.holderName!.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                      if (status.ticketType != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: config.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            status.ticketType!,
                            style: TextStyle(
                              color: config.color,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        status.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      if (status.isHeld)
                        Padding(
                              padding: const EdgeInsets.only(top: 24),
                              child: const Text(
                                "RELEASE TO CONTINUE",
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat())
                            .fadeIn()
                            .fadeOut(delay: 600.ms),
                    ],
                  ),
                ).animate().scale(
                  begin: const Offset(0.7, 0.7),
                  curve: Curves.elasticOut,
                  duration: 600.ms,
                ),
          ),
        ),
      ),
    );
  }
}
