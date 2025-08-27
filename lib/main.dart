import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:screenshot_detector/app.dart';
import 'package:screenshot_detector/overlay.dart';

void main() async {
  // Ensure all bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize communication port for foreground service
  FlutterForegroundTask.initCommunicationPort();

  runApp(const MainApp());
}

// overlay entry point
// @pragma("vm:entry-point")
// void overlayMain() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const OverlayMain());
// }

// overlay entry point
@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayMain());
}
