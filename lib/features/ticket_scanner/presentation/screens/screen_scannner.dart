import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/services/notification_provider.dart';

class ScannerScreen extends HookConsumerWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraController = useMemoized(() => MobileScannerController());
    final overlaystate=ref.read(notificationProvider.notifier);
    final animationController = useAnimationController(
      duration: const Duration(seconds: 2),
    );

    final isTorchOn = useState(false);

    useEffect(() {
      animationController.repeat(reverse: true);

      return () => cameraController.dispose();
    }, const []);

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double cutOutSize = screenWidth * 0.65;

    final Rect scanWindow = Rect.fromCenter(
      center: Offset(screenWidth / 2, screenHeight / 2.5),
      width: cutOutSize,
      height: cutOutSize,
    );
    // useAnimationValue to get the current value and trigger rebuilds only for the painter
    final animationValue = useAnimation(animationController);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: cameraController,
            scanWindow: scanWindow,
            onDetect: (capture) {
              final barcode = capture.barcodes.firstOrNull?.rawValue;
              if (barcode != null && barcode.trim().isNotEmpty) {
                overlaystate.emit(title: "SUCCESS", message:barcode, status: ValidationStatus.success, holderName: "Eric", ticketType: "Annual Tech Summit 2026");
              }
            },
            fit: BoxFit.cover,
          ),

          // Custom Overlay with Scanning Line
          CustomPaint(
            painter: ScannerOverlayPainter(
              scanLineOffset: animationValue,
            ),
            child: Container(),
          ),

          // Top Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Annual Tech Summit 2026",
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image_outlined, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                const Text(
                  "Align the QR code within the frame to scan",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 30),
                IconButton(
                  icon: Icon(
                    isTorchOn.value ? Icons.flashlight_on_outlined : Icons.flashlight_off_outlined,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () async {
                    await cameraController.toggleTorch();
                    isTorchOn.value = !isTorchOn.value;
                  },
                ),
                const SizedBox(height: 20),
                _buildStatusFooter(10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFooter(int scanCount) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: Colors.green, size: 12),
          const SizedBox(width: 8),
          const Text("ONLINE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(width: 16),
          Text("SCANS: $scanCount", style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

// Keep your ScannerOverlayPainter class exactly as it was...
class ScannerOverlayPainter extends CustomPainter {
  final double scanLineOffset;
  ScannerOverlayPainter({required this.scanLineOffset});

  @override
  void paint(Canvas canvas, Size size) {
    final double cutOutSize = size.width * 0.65;
    final Rect cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2.5),
      width: cutOutSize,
      height: cutOutSize,
    );

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(RRect.fromRectAndRadius(cutOutRect, const Radius.circular(8))),
      ),
      Paint()..color = Colors.black.withOpacity(0.5),
    );

    final borderPaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final double cornerLength = 20;

    canvas.drawPath(Path()
      ..moveTo(cutOutRect.left, cutOutRect.top + cornerLength)
      ..lineTo(cutOutRect.left, cutOutRect.top)
      ..lineTo(cutOutRect.left + cornerLength, cutOutRect.top), borderPaint);

    canvas.drawPath(Path()
      ..moveTo(cutOutRect.right - cornerLength, cutOutRect.top)
      ..lineTo(cutOutRect.right, cutOutRect.top)
      ..lineTo(cutOutRect.right, cutOutRect.top + cornerLength), borderPaint);

    canvas.drawPath(Path()
      ..moveTo(cutOutRect.left, cutOutRect.bottom - cornerLength)
      ..lineTo(cutOutRect.left, cutOutRect.bottom)
      ..lineTo(cutOutRect.left + cornerLength, cutOutRect.bottom), borderPaint);

    canvas.drawPath(Path()
      ..moveTo(cutOutRect.right - cornerLength, cutOutRect.bottom)
      ..lineTo(cutOutRect.right, cutOutRect.bottom)
      ..lineTo(cutOutRect.right, cutOutRect.bottom - cornerLength), borderPaint);

    final linePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 5
      ..shader = LinearGradient(
        colors: [Colors.blue.withOpacity(0.1), Colors.blue, Colors.blue.withOpacity(0.1)],
      ).createShader(Rect.fromLTWH(cutOutRect.left, cutOutRect.top + (cutOutRect.height * scanLineOffset), cutOutRect.width, 2));

    canvas.drawLine(
      Offset(cutOutRect.left, cutOutRect.top + (cutOutRect.height * scanLineOffset)),
      Offset(cutOutRect.right, cutOutRect.top + (cutOutRect.height * scanLineOffset)),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(ScannerOverlayPainter oldDelegate) => oldDelegate.scanLineOffset != scanLineOffset;
}