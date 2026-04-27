import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ticket_track/features/ticket_scanner/presentation/screens/result_overlay.dart';

class ScannerScreenS extends ConsumerStatefulWidget {
  const ScannerScreenS({super.key});

  @override
  ConsumerState<ScannerScreenS> createState() => _ScannerScreenSState();
}

class _ScannerScreenSState extends ConsumerState<ScannerScreenS> {
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final state = ref.watch(scannerControllerProvider);
    // final notifier = ref.read(scannerControllerProvider.notifier);

    // Synchronize camera state with validation state
    // if (state.isLoading || state.lastTicket != null || state.errorMessage != null) {
    //   _cameraController.stop();
    // } else {
    //   _cameraController.start();
    // }

    return Scaffold(
      body: Stack(
        children: [
          // 1. Camera Layer
          MobileScanner(
            controller: _cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                // notifier.handleScan(barcodes.first.rawValue!);
              }
            },
          ),

          // 2. UI Overlay Layer (Scanner Frame & Status)
          Positioned.fill(
            child: Container(
              decoration: ShapeDecoration(
                shape: QrScannerOverlayShape(
                  borderColor: Colors.white,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 250,
                ),
              ),
            ),
          ),

          // 3. Header Information
          // const SafeArea(child: ScannerStatusBar()),

          // 4. Validation Result Overlay
          // if (state.lastTicket != null || state.errorMessage != null)
          //   ResultOverlay(
          //     ticket: state.lastTicket,
          //     error: state.errorMessage,
          //     onDismiss: () => notifier.resetStatus(),
          //   ),
          //
          // if (state.isLoading)
          //   const Center(child: CircularProgressIndicator(color: Colors.white)),
        ],
      ),
    );
  }
}

// Custom Painter for the QR frame
class QrScannerOverlayShape extends ShapeBorder {
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 10,
    this.borderRadius = 10,
    this.borderLength = 30,
    this.cutOutSize = 250,
  });

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => Path();

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => Path()..addRect(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final backgroundPaint = Paint()..color = Colors.black54;
    final cutOutRect = Rect.fromCenter(
      center: rect.center,
      width: cutOutSize,
      height: cutOutSize,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(rect),
        Path()..addRRect(RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius))),
      ),
      backgroundPaint,
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawPath(
      Path()
        ..moveTo(cutOutRect.left, cutOutRect.top + borderLength)
        ..lineTo(cutOutRect.left, cutOutRect.top)
        ..lineTo(cutOutRect.left + borderLength, cutOutRect.top),
      borderPaint,
    );
    // (Additional corners omitted for brevity, repeat logic for all 4 corners)
  }

  @override
  ShapeBorder scale(double t) => this;
}