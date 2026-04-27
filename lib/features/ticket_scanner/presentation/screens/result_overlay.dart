import 'dart:async';
import 'package:flutter/material.dart';

class ResultOverlay extends StatefulWidget {
  // final Ticket? ticket;
  final String? error;
  final VoidCallback onDismiss;

  const ResultOverlay({super.key, this.error, required this.onDismiss});

  @override
  State<ResultOverlay> createState() => _ResultOverlayState();
}

class _ResultOverlayState extends State<ResultOverlay> {
  Timer? _dismissTimer;
  bool _isHeld = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _dismissTimer?.cancel();
    final duration = widget.error != null ? 1500 : 1000;
    _dismissTimer = Timer(Duration(milliseconds: duration), () {
      if (!_isHeld) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final bool isSuccess = widget.ticket != null;
    // final color = isSuccess ? Colors.green : Colors.red;
    final color =  Colors.green ;
    return GestureDetector(
      onLongPressStart: (_) {
        setState(() => _isHeld = true);
        _dismissTimer?.cancel();
      },
      onLongPressEnd: (_) {
        setState(() => _isHeld = false);
        widget.onDismiss(); // Immediate dismiss on release after hold
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        color: color.withOpacity(0.9),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                // isSuccess ? Icons.check_circle : Icons.error,error
                Icons.check_circle ,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              Text(
                 "ACCESS GRANTED" ,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              // if (isSuccess) ...[
              //   Text(widget.ticket!.holderName, style: const TextStyle(color: Colors.white, fontSize: 18)),
              //   Text(widget.ticket!.type, style: const TextStyle(color: Colors.white70, fontSize: 16)),
              // ] else
              //   Text(widget.error ?? "Invalid Ticket", style: const TextStyle(color: Colors.white, fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}