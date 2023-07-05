import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'scanner/app.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  runZonedGuarded(
    () => runApp(
      const App(),
    ),
    (error, stack) {},
  );
}
