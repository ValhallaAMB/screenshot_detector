import 'package:flutter/material.dart';
import 'package:screenshot_detector/app.dart';
import 'package:screenshot_detector/overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayMain());
}
