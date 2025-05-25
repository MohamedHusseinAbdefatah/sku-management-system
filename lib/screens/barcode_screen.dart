import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    autoStart: true,
    torchEnabled: false,
  );

  final _primaryColor = Colors.blue.shade800;
  bool _isScanning = true;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Barcode Scanner',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _controller.torchEnabled ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: () {
              _controller.toggleTorch();
              setState(() {});
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _buildScannerView(),
          _buildScannerOverlay(),
          _buildInstructions(),
          if (_hasError) _buildErrorState(),
        ],
      ),
    );
  }

  Widget _buildScannerView() {
    return MobileScanner(
      controller: _controller,
      onDetect: (capture) {
        if (!_isScanning) return;

        final barcodes = capture.barcodes;
        if (barcodes.isNotEmpty) {
          _isScanning = false;
          final skuCode = barcodes.first.rawValue ?? '';

          // Add brief feedback before closing
          Future.delayed(const Duration(milliseconds: 300), () {
            Navigator.pop(context, skuCode);
          });
        }
      },
      // errorBuilder: (context, error, child) {
      //   _hasError = true;
      //   return Center(child: Text(error.toString()));
      // },
    );
  }

  Widget _buildScannerOverlay() {
    return CustomPaint(painter: _ScannerOverlayPainter(), child: Container());
  }

  Widget _buildInstructions() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Text(
            'Align barcode within frame to scan',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            opacity: _isScanning ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: const Icon(
              Icons.vertical_align_bottom,
              color: Colors.white,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt, size: 60, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Camera initialization failed',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                _controller.start();
                setState(() => _hasError = false);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = Colors.red.shade400;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final scannerSize = size.width * 0.7;
    final centerOffset = Offset(size.width / 2, size.height / 2);
    final scannerRect = Rect.fromCenter(
      center: centerOffset,
      width: scannerSize,
      height: scannerSize * 0.6,
    );

    final clipPath = Path()..addRect(scannerRect);

    canvas.drawPath(
      Path.combine(PathOperation.difference, path, clipPath),
      paint..color = Colors.black.withOpacity(0.4),
    );

    // Draw scanner frame
    canvas.drawRRect(
      RRect.fromRectAndRadius(scannerRect, const Radius.circular(16)),
      paint..color = Colors.red.shade400,
    );

    // Draw animated corners
    final cornerPaint = Paint()
      ..color = Colors.red.shade400
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    const cornerLength = 30.0;
    // Top left
    canvas.drawLine(
      scannerRect.topLeft,
      scannerRect.topLeft.translate(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scannerRect.topLeft,
      scannerRect.topLeft.translate(0, cornerLength),
      cornerPaint,
    );

    // Top right
    canvas.drawLine(
      scannerRect.topRight,
      scannerRect.topRight.translate(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scannerRect.topRight,
      scannerRect.topRight.translate(0, cornerLength),
      cornerPaint,
    );

    // Bottom left
    canvas.drawLine(
      scannerRect.bottomLeft,
      scannerRect.bottomLeft.translate(cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scannerRect.bottomLeft,
      scannerRect.bottomLeft.translate(0, -cornerLength),
      cornerPaint,
    );

    // Bottom right
    canvas.drawLine(
      scannerRect.bottomRight,
      scannerRect.bottomRight.translate(-cornerLength, 0),
      cornerPaint,
    );
    canvas.drawLine(
      scannerRect.bottomRight,
      scannerRect.bottomRight.translate(0, -cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
