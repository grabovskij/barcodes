import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:barcode_scanner_generator/scanner/widgets/barcode_scan_widget.dart';
import 'package:barcode_scanner_generator/scanner/widgets/scan_overlay_widget.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({Key? key}) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  late final MobileScannerController scannerController;
  var isScanStarted = false;

  @override
  void initState() {
    scannerController = MobileScannerController(
      autoStart: false,
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
    super.initState();

    // Delay fixed unclosed keyboard
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 250)).whenComplete(
        () {
          setState(() {
            scannerController.start();
            isScanStarted = true;
          });
        },
      );
    });
  }

  @override
  void dispose() {
    scannerController.stop();
    scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
        title: const Text(
          'Сканер',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: isScanStarted
            ? Stack(
                children: [
                  SizedBox(
                    child: RepaintBoundary(
                      child: BarcodeScanWidget(
                        scannerController: scannerController,
                        onRecognized: (String barcode) {
                          context.pop(barcode);
                        },
                      ),
                    ),
                  ),
                  const ScanOverlay(),
                ],
              )
            : const Center(
                child: RepaintBoundary(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
