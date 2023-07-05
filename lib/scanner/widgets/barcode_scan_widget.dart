import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanWidget extends StatelessWidget {
  const BarcodeScanWidget({
    required this.scannerController,
    required this.onRecognized,
    this.barcodeType = BarcodeType.product,
    Key? key,
  }) : super(key: key);

  final MobileScannerController scannerController;
  final BarcodeType barcodeType;
  final Function(String barcode) onRecognized;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      startDelay: true,
      controller: scannerController,
      onDetect: (capture) async {
        final List<Barcode> barcodes = capture.barcodes;
        final Uint8List? image = capture.image;

        for (final barcode in barcodes) {
          checkBarcode(barcode);
        }
      },
    );
  }

  void checkBarcode(Barcode barcode) {
    if (barcode.rawValue == null) return;

    if (barcode.rawValue?.isEmpty ?? true) return;

    if (barcode.type != barcodeType) return;

    onRecognized.call(barcode.rawValue!);
  }
}
