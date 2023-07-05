import 'package:flutter/material.dart';

import 'scan_background_widget.dart';

class ScanOverlay extends StatelessWidget {
  const ScanOverlay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ColoredBox(
          color: Colors.lightGreenAccent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Отсканируйте штрихкод и найдите товар в\nприложении',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RepaintBoundary(
            child: LayoutBuilder(
              builder: (context, constraints) => ScanBG(
                size: Size(
                  constraints.maxWidth,
                  constraints.minHeight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
