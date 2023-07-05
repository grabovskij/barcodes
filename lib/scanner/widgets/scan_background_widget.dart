import 'package:flutter/material.dart';

import 'dart:ui' as ui;

class ScanBG extends StatefulWidget {
  const ScanBG({
    super.key,
    required this.size,
    this.lineLength = 50,
  });

  final Size size;
  final double lineLength;

  @override
  State<ScanBG> createState() => _ScanBGState();
}

class _ScanBGState extends State<ScanBG> with TickerProviderStateMixin {
  final Paint paint = Paint();
  late final AnimationController animationController;
  ui.Image? background;
  ui.Image? frame;

  @override
  void initState() {
    animationController = AnimationController(vsync: this)
      ..repeat(
        period: const Duration(seconds: 1),
        reverse: true,
      )
      ..addListener(() {
        setState(() {});
      });

    background = getBackground();
    frame = getFrame();

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: widget.size,
      painter: ScanBGPainter(
        animationController: animationController,
        painter: paint,
        background: background,
        frame: frame,
        curve: Curves.easeInOutExpo,
      ),
    );
  }

  ui.Image getBackground() {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    drawBackground(canvas, widget.size);

    return recorder.endRecording().toImageSync(
          widget.size.width.ceil(),
          widget.size.height.ceil(),
        );
  }

  void drawBackground(Canvas canvas, Size size) {
    final oldColor = paint.color;
    paint.color = Colors.black.withOpacity(0.4);

    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRect(
            Rect.fromCenter(
              center: Offset(
                size.width / 2,
                size.height / 2,
              ),
              width: size.width,
              height: size.height,
            ),
          ),
        Path()
          ..addRect(Rect.fromPoints(
            Offset(size.width / 5, size.height / 8 * 3),
            Offset(size.width / 5 * 4, size.height / 8 * 5),
          )),
      ),
      paint,
    );

    paint.color = oldColor;
  }

  ui.Image? getFrame() {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    drawFrame(canvas, widget.size);

    return recorder.endRecording().toImageSync(
          widget.size.width.ceil(),
          widget.size.height.ceil(),
        );
  }

  void drawFrame(Canvas canvas, Size size) {
    final oldColor = paint.color;
    final oldStrokeWidth = paint.strokeWidth;

    paint.color = Colors.white;
    paint.strokeWidth = 4;

    final point1 = Offset(size.width / 5, size.height / 8 * 3);
    final point2 = Offset(size.width / 5, size.height / 8 * 5);
    final point3 = Offset(size.width / 5 * 4, size.height / 8 * 3);
    final point4 = Offset(size.width / 5 * 4, size.height / 8 * 5);

    final center = Offset(size.width / 2, size.height / 2);

    // Top left
    canvas.drawLine(
      point1 + Offset(-paint.strokeWidth / 2, 0),
      point1 + Offset(widget.lineLength, 0),
      paint,
    );
    canvas.drawLine(
      point1 + Offset(0, -paint.strokeWidth / 2),
      point1 + Offset(0, widget.lineLength / 2 - paint.strokeWidth / 2),
      paint,
    );

    // Bottom left
    canvas.drawLine(
      point2 + Offset(-paint.strokeWidth / 2, 0),
      point2 + Offset(widget.lineLength, 0),
      paint,
    );
    canvas.drawLine(
      point2 + Offset(0, paint.strokeWidth / 2),
      point2 - Offset(0, widget.lineLength / 2 - paint.strokeWidth / 2),
      paint,
    );

    // Top right
    canvas.drawLine(
      point3 + Offset(paint.strokeWidth / 2, 0),
      point3 + Offset(-widget.lineLength, 0),
      paint,
    );
    canvas.drawLine(
      point3 + Offset(0, -paint.strokeWidth / 2),
      point3 + Offset(0, widget.lineLength / 2),
      paint,
    );

    // Bottom right
    canvas.drawLine(
      point4 + Offset(paint.strokeWidth / 2, 0),
      point4 + Offset(-widget.lineLength, 0),
      paint,
    );
    canvas.drawLine(
      point4 + Offset(0, paint.strokeWidth / 2),
      point4 + Offset(0, -widget.lineLength / 2),
      paint,
    );

    paint.color = oldColor;
    paint.strokeWidth = oldStrokeWidth;
  }
}

class ScanBGPainter extends CustomPainter {
  final AnimationController animationController;
  final Paint painter;
  final ui.Image? background;
  final ui.Image? frame;
  final Curve curve;

  ScanBGPainter({
    required this.animationController,
    required this.painter,
    this.background,
    this.frame,
    this.curve = Curves.linear,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (background != null) {
      canvas.drawImage(background!, Offset.zero, painter);
    }

    drawScanLine(size, canvas);

    if (frame != null) {
      canvas.drawImage(frame!, Offset.zero, painter);
    }
  }

  @override
  bool shouldRepaint(ScanBGPainter oldDelegate) => true;

  void drawScanLine(Size size, Canvas canvas) {
    final oldColor = painter.color;
    final oldStrokeWidth = painter.strokeWidth;
    painter.strokeWidth = 1.5;
    painter.color = Colors.red;
    final height = size.height / 8 * 3 +
        (curve.transform(animationController.value) * size.height / 4);
    final point1 = Offset(size.width / 5, height);
    final point2 = Offset(size.width / 5 * 4, height);
    canvas.drawLine(point1, point2, painter);
    painter.color = oldColor;
    painter.strokeWidth = oldStrokeWidth;
  }
}
